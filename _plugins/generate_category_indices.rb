require 'set'

module Jekyll
  class CategoryIndexPage < Jekyll::Page
    def initialize(site, base, dir, pages)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.md'

      self.process(@name)
      self.data = {}
      self.data['layout'] = 'default'

      dir_info   = site.data['directories'] && site.data['directories'][dir]
      dir_title  = dir_info && dir_info['title']
      dir_desc   = dir_info && dir_info['description']

      label = dir_title || begin
        l = dir.sub(%r{^content/}, '').split('/').last || 'Index'
        l.tr('-', ' ').split.map(&:capitalize).join(' ')
      end
      self.data['title']       = label
      self.data['description'] = dir_desc if dir_desc && !dir_desc.empty?

      self.content = build_content(pages, dir_desc)
    end

    def build_content(pages, dir_desc)
      sorted = pages.sort_by { |p| (p.data['title'] || p.data['name'] || '').downcase }
      list = sorted.map do |p|
        t = p.data['title'] ||
            File.basename(p.path, File.extname(p.path)).tr('-', ' ').split.map(&:capitalize).join(' ')
        desc = p.data['description']
        desc.nil? || desc.empty? ? "- [#{t}](#{p.url})" : "- [#{t}](#{p.url}) — #{desc}"
      end.join("\n")
      dir_desc && !dir_desc.empty? ? "#{dir_desc}\n\n#{list}" : list
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

      indexed_dirs = Set.new

      pages_by_dir.each do |dir, pages|
        full_dir = File.join(site.source, dir)
        if File.exist?(File.join(full_dir, 'index.md')) || File.exist?(File.join(full_dir, 'index.html'))
          indexed_dirs << dir
          next
        end
        next if dir == 'content'

        content_pages = pages.reject do |p|
          p.path.end_with?('/index.md') || p.path.end_with?('/index.html') || p.path == dir
        end

        next if content_pages.empty?

        site.pages << CategoryIndexPage.new(site, site.source, dir, content_pages)
        indexed_dirs << dir
      end

      Dir.glob('**/', base: content_root).sort.reverse.each do |subdir|
        next if subdir == '/'
        dir_path = "content/#{subdir}".chomp('/')
        full_dir = File.join(content_root, subdir)

        next if dir_path == 'content'
        next if indexed_dirs.include?(dir_path)

        children = Dir.glob('*/', base: full_dir).sort
        child_indices = children.map { |child|
          child_dir = File.join(dir_path, child.chomp('/'))
          site.pages.find { |p| File.dirname(p.path) == child_dir && p.name == 'index.md' }
        }.compact

        next if child_indices.empty?

        site.pages << CategoryIndexPage.new(site, site.source, dir_path, child_indices)
      end
    end
  end
end
