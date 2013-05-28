desc "Destroy your entire site."
task :nuke do
  rm_rf %w[.plugins _site config javascripts plugins public source stylesheets]
end
