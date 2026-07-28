module Jekyll
  class GenerateBuildData < Jekyll::Generator
    safe true
    priority :lowest

    def generate(site)
      site.data['page_urls'] = site.pages.map(&:url).uniq
    end
  end
end
