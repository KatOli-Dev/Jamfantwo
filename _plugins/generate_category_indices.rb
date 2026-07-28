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

      dirs = Dir.glob(File.join(content_root, '**', '')).select { |d| File.directory?(d) }
      dirs.map! { |d| d.sub(%r{/+$}, '') }

      dirs.each do |dir|
        next if File.exist?(File.join(dir, 'index.md'))
        next if File.exist?(File.join(dir, 'index.html'))

        relative = dir.sub(%r{^#{Regexp.escape(site.source)}/}, '')
        next if relative == 'content'

        pages = site.pages.select do |p|
          matches = p.path.start_with?(relative + '/')
          matches &&
            !p.path.end_with?('/index.md') &&
            !p.path.end_with?('/index.html') &&
            p.path != relative
        end

        next if pages.empty?

        site.pages << CategoryIndexPage.new(site, site.source, relative, pages)
      end
    end
  end
end
