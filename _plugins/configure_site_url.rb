Jekyll::Hooks.register :site, :after_init do |site|
  production_url = ENV['JEKYLL_SITE_URL']
  next if production_url.nil? || production_url.empty?

  site.config['url'] = production_url.chomp('/')
end
