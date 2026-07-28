module Jekyll
  class CategoryIndexPage < Jekyll::Page
    def initialize(site, base, dir, pages)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.md'

      self.process(@name)
      self.content = build_content(pages)
      self.data = {}
      self.data['layout'] = 'default'
      label = dir.sub(%r{^content/}, '').split('/').last
      self.data['title'] = label.tr('-', ' ').split.map(&:capitalize).join(' ')
    end

    def build_content(pages)
      sorted = pages.sort_by { |p| (p.data['title'] || p.data['name'] || '').downcase }
      sorted.map do |p|
        t = p.data['title'] ||
            File.basename(p.path, File.extname(p.path)).tr('-', ' ').split.map(&:capitalize).join(' ')
        "- [#{t}](#{p.url})"
      end.join("\n")
    end
  end

  class GenerateCategoryIndices < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      content_root = File.join(site.source, 'content')
      return unless Dir.exist?(content_root)

      pages_by_dir = Hash.new { |h, k| h[k] = [] }

      site.pages.each do |p|
        next unless p.path.start_with?('content/')
        dir = File.dirname(p.path)
        pages_by_dir[dir] << p
      end

      pages_by_dir.each do |dir, pages|
        full_dir = File.join(site.source, dir)
        next if File.exist?(File.join(full_dir, 'index.md'))
        next if File.exist?(File.join(full_dir, 'index.html'))
        next if dir == 'content'

        content_pages = pages.reject do |p|
          p.path.end_with?('/index.md') || p.path.end_with?('/index.html') || p.path == dir
        end

        next if content_pages.empty?

        site.pages << CategoryIndexPage.new(site, site.source, dir, content_pages)
      end
    end
  end
end
