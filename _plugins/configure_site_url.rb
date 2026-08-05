Jekyll::Hooks.register :site, :after_init do |site|
  production_url = ENV['JEKYLL_SITE_URL']
  if production_url && !production_url.empty?
    production_url = production_url.chomp('/')
    site.config['url'] = production_url
    site.config['site_url'] = production_url
  elsif Jekyll.env != 'production' && site.config['site_url'] == site.config['url']
    # Leave url/site_url blank so templates fall back to root-relative links
    # (e.g. "/content/foo/"). That way the test server works no matter what
    # host/IP/port it's reached through, instead of baking in one guessed
    # LAN address that only some visitors could actually use.
    site.config['url'] = ''
    site.config['site_url'] = ''
  end
end
