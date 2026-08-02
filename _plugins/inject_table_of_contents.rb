require 'cgi'

module Jekyll
  class InjectTableOfContents
    MARKER = '<!-- table-of-contents -->'
    HEADING_PATTERN = /<(h[23])\s+id="([^"]+)"[^>]*>(.*?)<\/\1>/im

    def self.generate(page)
      return unless page.output
      unless page.path.start_with?('content/')
        page.output = page.output.gsub(MARKER, '')
        return
      end

      headings = page.output.scan(HEADING_PATTERN).map do |level, id, content|
        text = content.gsub(/<[^>]*>/, '').strip
        [level, id, text]
      end

      toc = headings.length > 1 ? build_toc(headings) : ''
      page.output = page.output.gsub(MARKER, toc)
    end

    def self.build_toc(headings)
      builder = +"\n<nav class=\"table-of-contents\" aria-labelledby=\"table-of-contents-title\">\n"
      builder << "  <h2 id=\"table-of-contents-title\">Contents</h2>\n"
      builder << "  <ol>\n"
      open_heading = false
      open_sublist = false

      headings.each do |level, id, text|
        if level == 'h2'
          if open_heading
            builder << "      </ol>\n" if open_sublist
            builder << "    </li>\n"
          end
          builder << "    <li><a href=\"##{CGI.escapeHTML(id)}\">#{CGI.escapeHTML(text)}</a>\n"
          open_heading = true
          open_sublist = false
        else
          unless open_sublist
            builder << "      <ol>\n"
            open_sublist = true
          end
          builder << "        <li><a href=\"##{CGI.escapeHTML(id)}\">#{CGI.escapeHTML(text)}</a></li>\n"
        end
      end

      if open_heading
        builder << "      </ol>\n" if open_sublist
        builder << "    </li>\n"
      end
      builder << "  </ol>\n</nav>\n"
      builder
    end
  end

  Hooks.register :pages, :post_render do |page|
    InjectTableOfContents.generate(page)
  end
end
