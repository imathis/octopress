desc "Generate website and deploy"
task :gen_deploy => [:integrate, :generate, :deploy]
