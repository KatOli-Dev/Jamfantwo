require 'json'
require 'fileutils'

Jekyll::Hooks.register :site, :post_write do |site|
  entries = []

  site.pages.each do |page|
    next unless page.path.start_with?('content/')
    title = page.data['title']
    next unless title && !title.empty?

    snippet = page.content
      .gsub(/<[^>]*>/, '')
      .gsub(/\[([^\]]*)\]\([^)]*\)/, '\1')
      .gsub(/[*_#`>]/, '')
      .gsub(/\s+/, ' ')
      .strip[0, 400]

    entries << { title: title, url: page.url, snippet: snippet }
  end

  dest = File.join(site.dest, 'assets', 'search-index.json')
  FileUtils.mkdir_p(File.dirname(dest))
  File.write(dest, JSON.generate(entries))

  Jekyll.logger.info 'Search:', "index written to #{dest} (#{entries.length} pages)"
end
