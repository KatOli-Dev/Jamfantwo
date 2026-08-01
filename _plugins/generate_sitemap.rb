require 'fileutils'

Jekyll::Hooks.register :site, :post_write do |site|
  urls = []
  today = Time.now.strftime('%Y-%m-%d')
  base_url = "#{site.config['url']}#{site.config['baseurl']}"

  site.pages.each do |page|
    next if page.data['layout'] == 'redirect'
    next if page.data['sitemap'] == false
    next if page.name == '404.md'

    url = page.url
    url += '/' unless url.end_with?('/')
    loc = "#{base_url}#{url}"
    lastmod = page.data['last_modified'] || today

    urls << { loc: loc, lastmod: lastmod }
  end

  builder = +'<?xml version="1.0" encoding="UTF-8"?>'
  builder << '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
  urls.each do |entry|
    builder << '<url>'
    builder << "<loc>#{entry[:loc]}</loc>"
    builder << "<lastmod>#{entry[:lastmod]}</lastmod>"
    builder << '</url>'
  end
  builder << '</urlset>'

  dest = File.join(site.dest, 'sitemap.xml')
  File.write(dest, builder)

  Jekyll.logger.info 'Sitemap:', "written to #{dest} (#{urls.length} URLs)"
end
