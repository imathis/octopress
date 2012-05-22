module Octopress

  class RsyncDeployment < Deployment
    #include Rake::DSL

    def self.setup
      ssh_user = Octopress.ask("SSH login", "user@domain.com")
      ssh_port = Octopress.ask("SSH port", 22)
      document_root = Octopress.ask("Document root", "~/website.com/")
      delete = Octopress.ask("When syncing, do you want to delete files in #{document_root} which don't exist locally?", ["y", "n", "help"])
      delete_help = <<-DELETE
If you delete on sync:
1. Syncing will create a 1:1 match. Files will be added, updated and deleted from your server's #{document_root} to mirror your local copy.

If you do not delete:
1. You can store files in #{document_root} which aren't found in your local version.
2. Files you have removed from your local site must be removed manually from the server.

Do you want to delete on sync?
      DELETE
      delete = Octopress.ask(delete_help, ['y','n']) if delete == 'help'

      write_config({
        :method        => 'rsync',
        :ssh_user      => ssh_user,
        :ssh_port      => ssh_port,
        :document_root => document_root,
        :delete        => (delete === 'y') ? true : false
      })
      puts "\n## Now you can deploy to #{ssh_user}:#{document_root} with `rake deploy`. You can avoid entering your password, if your public key is listed in your server's ~/.ssh/authorized_keys file."
    end

    def self.deploy
      puts "## Deploying website via Rsync"
      system("rsync -avze 'ssh -p #{self.config['ssh_port']}' --delete #{self.config['public_dir']}/ #{self.config['ssh_user']}:#{self.config['document_root']}")
    end

  end

end

Octopress::Deployment.register_platform('rsync', Octopress::RsyncDeployment)
