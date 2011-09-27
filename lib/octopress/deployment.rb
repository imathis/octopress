require "right_aws"
require "digest/md5"
require "mime/types"
require 'net/dns/resolver'
require "public_suffix_service"

module Deployment
  module ClassMethods

    def deploy_rsync
      puts "## Deploying website via Rsync"
      ok_failed system("rsync -avz --delete #{self.config['public_dir']}/ #{self.config['ssh_user']}:#{self.config['document_root']}")
    end


    def deploy_github
      puts "## Deploying branch to Github Pages"
      Dir["#{self.config['deploy_dir']}/*"].each { |f| rm_rf(f) }
      system "cp -R #{self.config['destination']}/ #{self.config['deploy_dir']}"
      puts "\n## copying #{self.config['destination']} to #{self.config['deploy_dir']}"
      cd "#{self.config['deploy_dir']}" do
        system "git add ."
        system "git add -u"
        puts "\n## Commiting: Site updated at #{Time.now.utc}"
        message = "Site updated at #{Time.now.utc}"
        system "git commit -m \"#{message}\""
        puts "\n## Pushing generated #{self.config['deploy_dir']} website"
        system "git push origin #{deploy_branch}"
        puts "\n## Github Pages deploy complete"
      end
    end


    def deploy_heruku
      puts "## Deploying Octopress to Heroku"
      system "git push heroku master"
    end


    def deploy_amazon
      send("deploy_amazon_#{config['service']}")
    end
    
    def deploy_amazon_s3
      puts "## Deploying Octopress to Amazon S3"
      result = deploy_amazon_copy_to_s3
      deploy_amazon_route53_init(result[:bucket])
      puts "\n## Amazon S3 deploy complete"
    end

    def deploy_amazon_cloudfront
      puts "## Deploying Octopress to Amazon CloudFront"
      distribution = deploy_amazon_cloudfront_init()
      deploy_amazon_route53_init(distribution)
      result = deploy_amazon_copy_to_s3()
      deploy_amazon_cloudfront_invalidate(distribution, result['invalidation_paths'])
      puts "\n## Amazon CloudFront deploy complete"
    end
    
    def deploy_amazon_copy_to_s3
      s3_bucket = URI.parse(self.config['url']).host
      logger = Logger.new(STDOUT)
      logger.level = Logger::WARN
      s3 = RightAws::S3.new(self.config['aws_access_key_id'], self.config['aws_secret_access_key'], { :logger => logger })
      paths_to_invalidate = []
      # Retreive bucket or create it if not available
      bucket = s3.bucket(s3_bucket, true, 'public-read')
      Dir.glob("#{self.config['destination']}/**/*").each do |file|
        if File.file?(file)
          remote_file = file.gsub("#{self.config['destination']}/", "")
          key = bucket.key(remote_file, true)
          if !key || (key.e_tag != ("\"" + Digest::MD5.hexdigest(File.read(file))) + "\"")
            puts "Deploying file #{remote_file}"
            bucket.put(key, open(file), {}, 'public-read', {
              'content-type'        => MIME::Types.type_for(file).first.to_s,
              'x-amz-storage-class' => 'REDUCED_REDUNDANCY'
            })
            paths_to_invalidate << "/#{remote_file}"
          end
        end
      end
      return {
        "bucket" => bucket,
        "invalidation_paths" => paths_to_invalidate
      }
    end
    
    def deploy_amazon_cloudfront_init
      puts "Checking Amazon CloudFront environment"
      s3_bucket = URI.parse(self.config['url']).host
      logger = Logger.new(STDOUT)
      logger.level = Logger::WARN
      acf = RightAws::AcfInterface.new(self.config['aws_access_key_id'], self.config['aws_secret_access_key'], { :logger => logger })
      distributions = acf.list_distributions
      # Locate distribution by CNAME
      distributions = distributions.select { |distribution| distribution[:cnames].include?(s3_bucket) }
      # Create distribution if not found
      if (distributions.empty?) then
        puts "Creating Amazon CloudFront distribution... This usually requires a few minutes, please be patient!"
        config = {
          :enabled              => true,
          :comment              => "http://#{s3_bucket}",
          :cnames               => [ s3_bucket ],
          :s3_origin            => {
            :dns_name           => "#{s3_bucket}.s3.amazonaws.com"
          },
          :default_root_object  => 'index.html'
        }
        distributionID = acf.create_distribution(config)[:aws_id]
        # Wait for distribution to be created... This can take a while!
        while (acf.get_distribution(distributionID)[:status] == 'InProgress')
          puts "Still waiting for CloudFront distribution to be started..."
          sleep 30
        end
        distribution = distributions.select { |distribution| distribution[:cnames].include?(s3_bucket) }.first
        puts "Distribution #{distributionID} created and ready to serve your blog"
        
        if (self.config['managed_dns']) then
          deploy_amazon_cloudfront_route53_dns(distribution)
        end
        
        puts "Don't forget to setup your DNS properly. You should have something like this in your DNS zone file:"
        puts "\twww 10800 IN CNAME #{distributionID}.cloudfront.net."
      else
        distribution = distributions.first
        puts "Distribution #{distribution[:aws_id]} found"
      end
      return distribution
    end
    
    def deploy_amazon_cloudfront_invalidate(distribution, paths_to_invalidate)
      if (paths_to_invalidate.empty?) then
        return;
      end
      puts "Invalidating CloudFront caches..."
      logger = Logger.new(STDOUT)
      logger.level = Logger::WARN
      acf = RightAws::AcfInterface.new(self.config['aws_access_key_id'], self.config['aws_secret_access_key'], { :logger => logger })
      acf.create_invalidation distribution[:aws_id], :path => paths_to_invalidate
    end
    
    def deploy_amazon_route53_init(source)
      if (self.config['managed_dns'] == 'n') then
        return
      end
      
      puts "Checking Amazon Route53 environment"
      logger = Logger.new(STDOUT)
      logger.level = Logger::WARN
      r53 = RightAws::Route53Interface.new(self.config['aws_access_key_id'], self.config['aws_secret_access_key'], { :logger => logger })
      host = URI.parse(self.config['url']).host
      domain = PublicSuffixService.parse(host).domain
      
      # Locate zones by domain name
      zone = r53.list_hosted_zones.select { |zone| zone[:name] == "#{domain}." }
      if (zone.empty?) then
        hosted_zone_config = {
          :name   => "#{domain}.",
          :config => {
            :comment => 'My Octopress site!'
          }
        }
        puts "## Creating Route53 zone for domain #{domain}"
        zone = r53.create_hosted_zone(hosted_zone_config)
      else
        zone = zone[0]
      end
      
      # Setup the 'www' record if needed
      resource_record_sets = r53.list_resource_record_sets(zone[:aws_id])
      if (self.config['service'] == 's3') then
        puts "Octopress can't manage deployments to Amazon S3 with Route53 yet."
        puts "Modify your 'amazon.yml' file so that 'managed_dns' is set to 'n' until this feature is supported."
      elsif (self.config['service'] == 'cloudfront') then
        if (resource_record_sets.count { |record| record[:name] == "#{domain}." && record[:type] == 'A'} == 0) then
          new_resource_record_sets = [{
              :name => "www.#{domain}.",
              :type => 'CNAME',
              :ttl => 14400,
              :resource_records => "#{source[:domain_name]}"
            }, {    # WWWizer service 
              :name => "#{domain}.",
              :type => 'A',
              :ttl => 14400,
              :resource_records => ['174.129.25.170']
            }]
          r53.create_resource_record_sets(zone[:aws_id], new_resource_record_sets, 'My Octopress records')
          puts "Amazon Route53: zone created for your domain '#{domain}'"
        end
      else
        raise "Unknow Amazon service: #{self.config['service']
        self.config['service']}"
      end
      
      # Check domain name configuration for appropriate DNS servers
      packet = Net::DNS::Resolver.start(domain, Net::DNS::NS)
      current_dns_servers = packet.answer.collect { |ns| ns.nsdname }
      amazon_dns_servers = resource_record_sets.reject { |record| record[:type] != 'NS' }.collect { |ns| ns[:resource_records] }.flatten
      unless ((amazon_dns_servers - current_dns_servers).empty?) then
        puts "####################################################################################################################"
        puts "# Your DNS Setup is invalid!"
        puts "#"
        puts "# Your current DNS servers are:"
        current_dns_servers.each { |dns|
          puts "# - #{dns}"
        }
        puts "#"
        puts "# You should set the following DNS servers for your domain '#{domain}' instead:"
        amazon_dns_servers.each { |dns|
          puts "# - #{dns}"
        }
        puts "####################################################################################################################"
      end
    end
    
  end
end
