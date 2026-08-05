require 'open3'

module Jekyll
  class InjectLastModified < Jekyll::Generator
    safe true
    priority :lowest

    def generate(site)
      site.pages.each do |page|
        next unless page.path.start_with?('content/')
        source_path = File.join(site.source, page.path)
        next unless File.exist?(source_path)

        timestamp, _status = Open3.capture2('git', 'log', '-1', '--format=%ai', '--', source_path)
        timestamp = timestamp.strip
        next if timestamp.empty?

        page.data['last_modified'] = timestamp
      end
    end
  end
end
