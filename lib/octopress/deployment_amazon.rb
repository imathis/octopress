require "right_aws"
require "digest/md5"
require "mime/types"
require 'net/dns/resolver'
require "public_suffix_service"

module Deployment
  class Amazon
    @config
    
    def self.deploy_amazon_s3(config)
      @config = config
      puts "## Deploying Octopress to Amazon S3"
      result = deploy_website_to_s3
      route53_init(result[:bucket])
      puts "\n## Amazon S3 deploy complete"
    end

    def self.deploy_amazon_cloudfront(config)
      @config = config
      puts "## Deploying Octopress to Amazon CloudFront"
      distribution = cloudfront_init()
      route53_init(distribution)
      result = deploy_website_to_s3()
      cloudfront_invalidate(distribution, result['invalidation_paths'])
      puts "\n## Amazon CloudFront deploy complete"
    end
    
    def self.deploy_website_to_s3
      s3_bucket = URI.parse(@config['url']).host
      logger = Logger.new(STDOUT)
      logger.level = Logger::WARN
      s3 = RightAws::S3.new(@config['aws_access_key_id'], @config['aws_secret_access_key'], { :logger => logger })
      paths_to_invalidate = []
      # Retreive bucket or create it if not available
      my_buckets_names = s3.buckets.map{|b| b.name}
      unless (my_buckets_names.include?(s3_bucket)) then
        puts "# Creating Amazon S3 Bucket... Don't forget to turn on website configuration via the management console..."
        puts "# ... at 'https://console.aws.amazon.com/s3/home' and set the default root to 'index.html'"
      end
      bucket = s3.bucket(s3_bucket, true, 'public-read')
      Dir.glob("#{@config['destination']}/**/*").each do |file|
        if File.file?(file)
          remote_file = file.gsub("#{@config['destination']}/", "")
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
    
    def self.cloudfront_init
      puts "Checking Amazon CloudFront environment"
      s3_bucket = URI.parse(@config['url']).host
      logger = Logger.new(STDOUT)
      logger.level = Logger::WARN
      acf = RightAws::AcfInterface.new(@config['aws_access_key_id'], @config['aws_secret_access_key'], { :logger => logger })
      distributions = acf.list_distributions
      # Locate distribution by CNAME
      distributions = distributions.select { |distribution|
        unless distribution[:cnames] == nil then
          distribution[:cnames].include?(s3_bucket)
        end
      }
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
      else
        distribution = distributions.first
        puts "Distribution #{distribution[:aws_id]} found"
      end
      return distribution
    end
    
    def self.cloudfront_invalidate(distribution, paths_to_invalidate)
      if (paths_to_invalidate.empty?) then
        return;
      end
      puts "Invalidating CloudFront caches..."
      logger = Logger.new(STDOUT)
      logger.level = Logger::WARN
      acf = RightAws::AcfInterface.new(@config['aws_access_key_id'], @config['aws_secret_access_key'], { :logger => logger })
      acf.create_invalidation distribution[:aws_id], :path => paths_to_invalidate
    end
    
    # Route53 gem documentation: http://rubydoc.info/gems/right_aws/2.1.0/RightAws/Route53Interface
    def self.route53_init(source)
      if (@config['managed_dns'] == 'n') then
        return
      end
      
      puts "Checking Amazon Route53 environment"
      logger = Logger.new(STDOUT)
      logger.level = Logger::WARN
      r53 = RightAws::Route53Interface.new(@config['aws_access_key_id'], @config['aws_secret_access_key'], { :logger => logger })
      host = URI.parse(@config['url']).host
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
      if (@config['service'] == 's3') then
        puts "Octopress can't manage deployments to Amazon S3 with Route53 yet."
        puts "Modify your 'amazon.yml' file so that 'managed_dns' is set to 'n' until this feature is supported."
      elsif (@config['service'] == 'cloudfront') then
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
        else
          puts "Amazon Route53 setup OK"
        end
      else
        raise "Unknow Amazon service: #{@config['service']
        @config['service']}"
      end
      
      # Check domain name configuration for appropriate DNS servers
      puts "Checking DNS configuration for domain '#{domain}'"
      current_dns_servers = []
      amazon_dns_servers = resource_record_sets.reject { |record| record[:type] != 'NS' }.collect { |ns| ns[:resource_records] }.flatten
      begin
        packet = Net::DNS::Resolver.start(domain, Net::DNS::NS)
        current_dns_servers = packet.answer.collect { |ns| ns.nsdname }
      rescue
      end
      if (current_dns_servers.empty?) then
        puts "####################################################################################################################"
        puts "# Could not check DNS settings. Check the name servers declared for your domain '#{domain}':"
        puts "#"
        amazon_dns_servers.each { |dns|
          puts "# - #{dns}"
        }
        puts "####################################################################################################################"
      else
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
    
    # Delete zone records and the zone itself
    def self.route53_destroy_zone(zone)
      resource_record_sets = r53.list_resource_record_sets(zone[:aws_id])
      resource_record_sets = resource_record_sets.reject { |record| record[:type] == 'NS' || record[:type] == 'SOA' }
      r53.delete_resource_record_sets(zone[:aws_id], resource_record_sets, 'kill all records I have created')
      r53.delete_hosted_zone(zone[:aws_id])
    end
    
  end
end