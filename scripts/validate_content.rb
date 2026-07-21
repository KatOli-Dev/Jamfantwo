#!/usr/bin/env ruby
require 'pathname'

ROOT = Pathname.new(File.expand_path('..', __dir__))
CONTENT_DIR = ROOT.join('content')
SITE_DIR = ROOT.join('_site')
SITE_INDEX = SITE_DIR.join('index.html')
INDEX_MD = ROOT.join('index.md')

MIN_WORDS = 1000

@failures = []
@warnings = []

def fail(file, line, msg)
  rel = file.relative_path_from(ROOT).to_s
  @failures << "#{rel}:#{line}: #{msg}"
end

def warn(file, line, msg)
  rel = file.relative_path_from(ROOT).to_s
  @warnings << "#{rel}:#{line}: #{msg}"
end

def parse_front_matter(text)
  if text.start_with?("---")
    parts = text.split(/^---\s*$/, 3)
    return parts[1].to_s, parts[2].to_s if parts.length >= 3
  end
  [nil, text]
end

def parse_front_matter_yaml(yaml_text)
  result = {}
  in_list = nil
  yaml_text.each_line do |raw|
    line = raw.chomp.sub(/\s*#.*\z/, '')
    next if line.strip.empty?
    if line =~ /\A-\s+(.*)\z/
      result[in_list] ||= []
      result[in_list] << $1.strip
      next
    end
    if line =~ /\A([A-Za-z0-9_-]+):\s*(.*)\z/
      key = $1
      val = $2
      if val.strip.empty?
        in_list = key
      else
        in_list = nil
        val = val.strip
        val = val[1..-2] if val.start_with?('"') && val.end_with?('"')
        val = val[1..-2] if val.start_with?("'") && val.end_with?("'")
        result[key] = val
      end
    end
  end
  result
end

def strip_code_blocks(body)
  out = []
  in_fence = false
  body.each_line do |line|
    if line =~ /\A(\s*)(```|~~~)/
      in_fence = !in_fence
      next
    end
    out << line unless in_fence
  end
  out.join
end

def strip_link_destinations(text)
  text.gsub(/\[([^\]]*)\]\(([^)]*)\)/) { |_m| $1 }
     .gsub(/^\s*\{:[^}]*\}\s*$/, '')
     .gsub(/!\[[^\]]*\]\([^)]*\)/, '')
end

def strip_indented_code(text)
  out = []
  in_block = false
  text.each_line do |line|
    if line =~ /\A( {4,}|\t)/
      in_block = true
      next
    elsif line.strip.empty?
      out << line if !in_block
      next
    else
      in_block = false
      out << line
    end
  end
  out.join
end

def strip_html_comments(text)
  text.gsub(/<!--.*?-->/m, '')
end

def count_words(text)
  text.split(/\s+/).reject(&:empty?).length
end

def expected_opening(rel_path)
  if rel_path.start_with?('content/species/sapient/')
    '## Origins'
  else
    '## Overview'
  end
end

def check_file(file)
  rel = file.relative_path_from(ROOT).to_s
  text = file.read
  fm_text, body = parse_front_matter(text)

  if fm_text.nil?
    fail(file, 1, "missing front matter (expected --- delimiters)")
    return
  end

  fm = parse_front_matter_yaml(fm_text)
  fm_line_offset = fm_text.lines.length + 2

  if fm['layout'].nil?
    fail(file, fm_line_offset, "front matter missing 'layout'")
  elsif fm['layout'].to_s.strip != 'default'
    fail(file, fm_line_offset, "front matter layout must be 'default' (got #{fm['layout'].inspect})")
  end

  title = fm['title']
  if title.nil? || title.to_s.strip.empty?
    fail(file, fm_line_offset, "front matter missing 'title'")
  end

  expected = expected_opening(rel)
  body_lines = body.lines
  headings = []
  body_lines.each_with_index do |line, idx|
    line_no = idx + fm_line_offset + 1
    next if line.strip.empty?
    if line =~ /\A#\s/
      fail(file, line_no, "H1 heading not allowed in body (layout renders the h1)")
    end
    if line =~ /\A#{'#' * 7}\s/
      warn(file, line_no, "excessively deep heading")
    end
    if line =~ /\A(={2,}|-{2,})\s*\z/
      fail(file, line_no, "setext-style heading underline not allowed (use ATX headings)")
    end
    if line =~ /\A(#+)\s/
      level = $1.length
      headings << [line_no, level, line.strip]
    end
    if line =~ /\*\*[^*\n]+\*\*/
      fail(file, line_no, "bold (**text**) emphasis not allowed")
    end
    if line =~ /(^|[^*])\*[^*\n]+\*/
      fail(file, line_no, "italic (*text*) emphasis not allowed")
    end
    if line =~ /\p{Han}|\p{Hiragana}|\p{Katakana}|\p{Hangul}/u
      fail(file, line_no, "anomalous CJK script in English prose")
    end
    if line =~ /[\u{1F300}-\u{1FAFF}\u{2600}-\u{27BF}]/
      fail(file, line_no, "pictograph/emoji not allowed")
    end
    line.scan(/(\b)a\s+([aeiouAEIOU][\w\[\(]*)/) do |_, word|
      base = word.sub(/\A[\[\(]+/, '')
      next if base =~ /\A(eu|ew|one|once|un[iu])/i
      fail(file, line_no, "possible article error: 'a #{base}' (use 'an' before vowel)")
    end
    line.scan(/(\b)an\s+([bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ][\w\[\(]*)/) do |_, word|
      base = word.sub(/\A[\[\(]+/, '')
      next if base =~ /\A(h[aeiou]|hour|honest|honor)/i
      fail(file, line_no, "possible article error: 'an #{base}' (use 'a' before consonant)")
    end
  end

  if headings.empty?
    fail(file, fm_line_offset, "body has no ATX headings")
  else
    opening = headings.first
    if opening[2] != expected
      fail(file, opening[0], "first body heading must be '#{expected}' for this category (got '#{opening[2]}')")
    end
    headings.each_cons(2) do |a, b|
      jump = b[1] - a[1]
      if jump > 1
        fail(file, b[0], "heading level skipped from h#{a[1]} to h#{b[1]}")
      end
    end
  end

  body_no_code = strip_code_blocks(body)
  body_no_code = strip_indented_code(body_no_code)
  body_prose = strip_link_destinations(body_no_code)
  body_prose = strip_html_comments(body_prose)
  words = count_words(body_prose)
  if words < MIN_WORDS
    fail(file, 1, "body has #{words} words; minimum is #{MIN_WORDS}")
  end

  check_internal_links(file, body, fm_line_offset)
end

def normalize_link_text(text)
  text.to_s.downcase
      .sub(/\A(the|a|an)\s+/, '')
      .gsub(/[^\w\s]/, '')
      .gsub(/\s+/, ' ')
      .strip
end

def link_text_matches(link_text, title)
  l = normalize_link_text(link_text)
  t = normalize_link_text(title)
  return true if l == t
  return false if l.length < 4 || t.length < 4
  return true if l.include?(t) || t.include?(l)
  common = 0
  [l.length, t.length].min.times { |i| break if l[i] != t[i]; common += 1 }
  return true if common.to_f / [l.length, t.length].min >= 0.6
  false
end

def title_for_path(path)
  source = ROOT.join(path + '.md')
  source = ROOT.join(path, 'index.md') unless source.exist?
  return nil unless source.exist?
  text = source.read
  fm_text, _ = parse_front_matter(text)
  return nil if fm_text.nil?
  fm = parse_front_matter_yaml(fm_text)
  fm['title']
end

def check_internal_links(file, body, line_offset)
  body.each_line.with_index do |line, idx|
    line.scan(/\[([^\]]*)\]\((\/content\/[A-Za-z0-9_\-\/\.]+)\)/) do |match|
      link_text, url = match
      abs_line = idx + line_offset + 1
      path = url[1..]
      source = ROOT.join(path + '.md')
      unless source.exist?
        source_alt = ROOT.join(path, 'index.md')
        unless source_alt.exist?
          fail(file, abs_line, "internal link #{url} does not resolve to a source page")
          next
        end
      end
      title = title_for_path(path)
      next unless title
      if !link_text_matches(link_text, title)
        warn(file, abs_line,
             "link text '#{link_text}' for #{url} does not match target page title '#{title}'")
      end
    end
  end
end

content_files = CONTENT_DIR.glob('**/*.md').sort

content_files.each do |f|
  check_file(f)
end

def collect_content_slugs
  CONTENT_DIR.glob('**/*.md').map { |f| f.relative_path_from(CONTENT_DIR).to_s.sub(/\.md\z/, '') }
end

def linked_from_index
  sources = []
  sources << SITE_INDEX if SITE_INDEX.exist?
  sources << INDEX_MD if INDEX_MD.exist?
  seen = {}
  sources.each do |src|
    text = src.read
    text.scan(/\[[^\]]*\]\((\/[A-Za-z0-9_\-\/\.]+)\)/) do |match|
      url = match.is_a?(Array) ? match[0] : match
      path = url[1..].sub(/\.html\z/, '')
      next unless path.start_with?('content/')
      slug = path.sub(/\Acontent\//, '').sub(%r{/index\z}, '')
      seen[slug] = src
    end
    text.scan(/<a[^>]+href="(\/[A-Za-z0-9_\-\/\.]+)"/) do |match|
      url = match.is_a?(Array) ? match[0] : match
      path = url[1..].sub(/\.html\z/, '').sub(/\/\z/, '')
      next unless path.start_with?('content/')
      slug = path.sub(/\Acontent\//, '').sub(%r{/index\z}, '')
      seen[slug] = src
    end
  end
  seen
end

all_slugs = collect_content_slugs
linked = linked_from_index
all_slugs.each do |slug|
  unless linked.key?(slug)
    fail(INDEX_MD, 1, "orphan content page not linked from generated index: #{slug}")
  end
end

def check_rendered_links
  return unless SITE_DIR.exist?

  SITE_DIR.glob('**/*.html').sort.each do |file|
    file.read.scan(/(?:href|src)=["']([^"']+)["']/) do |match|
      url = match[0]
      next unless url.start_with?('/')
      path = url.split(/[?#]/, 2).first.sub(%r{\A/}, '')
      next if path.empty?

      target = SITE_DIR.join(path)
      candidates = [target, Pathname.new("#{target}.html"), target.join('index.html')]
      unless candidates.any?(&:file?)
        fail(file, 1, "rendered internal URL #{url} does not resolve in _site")
      end
    end
  end
end

check_rendered_links

unless @failures.empty?
  puts "Validation failed with #{@failures.length} failure(s):"
  @failures.sort.each { |m| puts "  #{m}" }
end

unless @warnings.empty?
  puts "Warnings (#{@warnings.length}):"
  @warnings.sort.each { |m| puts "  #{m}" }
end

if @failures.empty?
  puts "All checks passed."
  exit 0
else
  exit 1
end
