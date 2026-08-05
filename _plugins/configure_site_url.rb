Jekyll::Hooks.register :site, :after_init do |site|
  production_url = ENV['JEKYLL_SITE_URL']
  explicit_url = ENV['JEKYLL_PUBLIC_URL']

  if production_url && !production_url.empty?
    production_url = production_url.chomp('/')
    site.config['url'] = production_url
    site.config['site_url'] = production_url
  elsif Jekyll.env != 'production' && (explicit_url.nil? || explicit_url.empty?)
    # Leave url/site_url blank so templates fall back to root-relative links
    # (e.g. "/content/foo/"). That way the test server works no matter what
    # host/IP/port it's reached through, instead of baking in one absolute
    # address that only some visitors could actually use. Unconditional (not
    # gated on comparing url/site_url) because `jekyll serve` itself rewrites
    # config['url'] to "http://localhost:<port>" whenever Jekyll.env is
    # "development", which would otherwise make an equality check unreliable.
    site.config['url'] = ''
    site.config['site_url'] = ''
  end
end
