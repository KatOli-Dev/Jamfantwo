module Jekyll
  class GlossaryPage < Jekyll::Page
    def initialize(site, base, entries)
      @site = site
      @base = base
      @dir = 'glossary'
      @name = 'index.html'

      self.process(@name)
      self.content = build_content(entries)
      self.data = {}
      self.data['layout'] = 'default'
      self.data['title'] = 'Glossary'
      self.data['description'] = 'An index of in-universe terms, each linked to the page that defines it in depth.'
    end

    def build_content(entries)
      sorted = entries.sort_by { |e| e['term'].downcase }
      lines = []
      sorted.each do |e|
        term = e['term']
        definition = e['definition']
        url = e['url']
        lines << "## #{term}\n\n#{definition}\n\n[Read more](#{url})\n"
      end
      lines.join("\n---\n\n")
    end
  end

  class GenerateGlossary < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      entries = site.data['glossary']
      return unless entries && entries.is_a?(Array) && !entries.empty?

      site.pages << GlossaryPage.new(site, site.source, entries)
    end
  end
end
