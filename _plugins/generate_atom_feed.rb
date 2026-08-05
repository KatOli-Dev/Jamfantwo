require 'time'
require 'cgi'

Jekyll::Hooks.register :site, :post_write do |site|
  entries = []
  now = Time.now.utc
  base_url = site.config['site_url']

  site.pages.each do |page|
    next if page.data['layout'] == 'redirect'
    next if page.data['sitemap'] == false
    next if page.name == '404.md'
    next unless page.url.start_with?('/content/') || page.url == '/'

    title = page.data['title'] or next
    description = page.data['description'].to_s.strip
    next if description.empty?
    next if page.name == 'index.md' && !File.exist?(File.join(site.source, page.path))

    url = page.url
    url += '/' unless url.end_with?('/')

    last_modified = page.data['last_modified']
    updated = last_modified ? Time.parse(last_modified).utc : now

    entries << {
      title: title,
      url: url,
      id: "#{base_url}#{url}",
      updated: updated,
      description: description
    }
  end

  entries.sort_by! { |e| e[:updated] }.reverse!

  builder = +"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
  builder << "<feed xmlns=\"http://www.w3.org/2005/Atom\">\n"
  builder << "  <title>#{CGI.escapeHTML(site.config['title'])}</title>\n"
  builder << "  <subtitle>#{CGI.escapeHTML(site.config['description'])}</subtitle>\n"
  builder << "  <link href=\"#{base_url}/\"/>\n"
  builder << "  <link href=\"#{base_url}/feed.xml\" rel=\"self\"/>\n"
  builder << "  <updated>#{now.xmlschema}</updated>\n"
  builder << "  <id>#{base_url}/</id>\n"
  authors = site.config['authors']
  if authors.nil? || authors.empty?
    builder << "  <author><name>#{CGI.escapeHTML(site.config['title'])}</name></author>\n"
  else
    authors.each do |author|
      builder << "  <author><name>#{CGI.escapeHTML(author)}</name></author>\n"
    end
  end

  entries.first(50).each do |e|
    builder << "  <entry>\n"
    builder << "    <title>#{CGI.escapeHTML(e[:title])}</title>\n"
    builder << "    <link href=\"#{base_url}#{e[:url]}\"/>\n"
    builder << "    <id>#{e[:id]}</id>\n"
    builder << "    <updated>#{e[:updated].xmlschema}</updated>\n"
    builder << "    <summary>#{CGI.escapeHTML(e[:description])}</summary>\n"
    builder << "  </entry>\n"
  end

  builder << "</feed>\n"

  dest = File.join(site.dest, 'feed.xml')
  File.write(dest, builder)

  Jekyll.logger.info 'Atom feed:', "written to #{dest} (#{entries.length} entries)"
end
