#!/usr/bin/env ruby
require 'pathname'
require 'json'

ROOT = Pathname.new(File.expand_path('..', __dir__))
CONTENT_DIR = ROOT.join('content')
OUTPUT = ROOT.join('assets', 'search-index.json')

def extract_front_matter_yaml(text)
  return nil unless text.start_with?("---")
  parts = text.split(/^---\s*$/, 3)
  return nil if parts.length < 3
  parts[1]
end

def extract_body(text)
  return text unless text.start_with?("---")
  parts = text.split(/^---\s*$/, 3)
  parts.length >= 3 ? parts[2].to_s : text
end

def strip_markdown(text)
  text.gsub(/\[([^\]]*)\]\([^)]*\)/, '\1')
      .gsub(/[*_#`>]/, '')
      .gsub(/\n{2,}/, "\n")
      .gsub(/\s+/, ' ')
      .strip
end

def slug_to_url(rel_path)
  parts = rel_path.sub(/\.md\z/, '').split('/')
  '/' + parts.join('/')
end

def parse_title(yaml_text)
  title_line = yaml_text.each_line.find { |l| l.match?(/\Atitle:\s*/) }
  return nil unless title_line
  title_line.sub(/\Atitle:\s*/, '').strip.gsub(/\A"|"\z/, '').gsub(/\A'|'\z/, '')
end

entries = []

CONTENT_DIR.glob('**/*.md').sort.each do |file|
  text = file.read
  yaml_text = extract_front_matter_yaml(text)
  next unless yaml_text

  title = parse_title(yaml_text)
  next unless title && !title.empty?

  body = extract_body(text)
  clean = strip_markdown(body)
  snippet = clean[0, 400]

  rel = file.relative_path_from(ROOT).to_s
  url = slug_to_url(rel)

  entries << { title: title, url: url, snippet: snippet }
end

OUTPUT.write(JSON.generate(entries))

total_size = File.size(OUTPUT)
puts "Search index: #{entries.length} pages, #{total_size} bytes written to #{OUTPUT}"
