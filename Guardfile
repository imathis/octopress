
guard 'jekyll-plus', serve: ENV['JEKYLL_SERVE'], drafts: ENV['JEKYLL_DRAFTS'] do
  watch /^source/
  watch /^_config\.yml/
end

guard 'compass' do
  watch %r{^sass/(.*)\.s[ac]ss$}
end

