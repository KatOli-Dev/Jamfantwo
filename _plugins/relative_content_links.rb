Jekyll::Hooks.register :site, :post_write do |site|
  site_url = site.config['site_url'].to_s.chomp('/')
  next if site_url.empty?

  Dir.glob(File.join(site.dest, '**', '*.html')).each do |path|
    html = File.read(path)
    rewritten = html.gsub(/(href=["'])\/content\//) do
      "#{$1}#{site_url}/content/"
    end
    File.write(path, rewritten) unless rewritten == html
  end
end
