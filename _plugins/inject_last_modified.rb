module Jekyll
  class InjectLastModified < Jekyll::Generator
    safe true
    priority :lowest

    def generate(site)
      site.pages.each do |page|
        next unless page.path.start_with?('content/')
        source_path = File.join(site.source, page.path)
        next unless File.exist?(source_path)

        timestamp = `git log -1 --format=%ai -- "#{source_path}" 2>/dev/null`.strip
        next if timestamp.empty?

        page.data['last_modified'] = timestamp
      end
    end
  end
end
