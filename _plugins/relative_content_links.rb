Jekyll::Hooks.register :site, :post_write do |site|
  baseurl = site.baseurl.to_s.chomp('/')
  next if baseurl.empty?

  Dir.glob(File.join(site.dest, '**', '*.html')).each do |path|
    html = File.read(path)
    rewritten = html.gsub(/(href=["'])\/content\//) do
      "#{$1}#{baseurl}/content/"
    end
    File.write(path, rewritten) unless rewritten == html
  end
end
