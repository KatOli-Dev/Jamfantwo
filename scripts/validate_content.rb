#!/usr/bin/env ruby
require 'pathname'
require 'yaml'

ROOT = Pathname.new(File.expand_path('..', __dir__))
CONTENT_DIR = ROOT.join('content')
INDEX_MD = ROOT.join('index.md')
CONFIG_PATH = ROOT.join('scripts', 'validator_config.yml')

MIN_WORDS = 1000

unless CONFIG_PATH.exist?
  abort("missing validator config: #{CONFIG_PATH}")
end

VALIDATOR_CONFIG = YAML.load_file(CONFIG_PATH)

def article_exception_regex(key)
  entries = VALIDATOR_CONFIG.dig('article_exceptions', key) || []
  patterns = entries.map { |e| e['pattern'].to_s }
  return nil if patterns.empty?
  "(#{patterns.join('|')})"
end

A_BEFORE_VOWEL_RE = article_exception_regex('a_before_vowel')
AN_BEFORE_CONSONANT_RE = article_exception_regex('an_before_consonant')

LINK_TEXT_EXCEPTION_PATTERNS = (VALIDATOR_CONFIG.dig('link_text_exceptions', 'universal') || [])
  .map { |e| Regexp.new(e['pattern'].to_s) }

# Mirror of the filtering in _includes/content-list.html. A content page is
# considered listed by the homepage index if any rule matches. Keep this list
# in sync with the include.
INDEX_TITLE_RULES = %w[geography population].freeze
INDEX_PATH_RULES = [
  'content/art/',
  'content/culture/',
  'content/economy/',
  'content/law/',
  'content/military/',
  'content/mythology/',
  ['content/nature/', 'flora'],
  ['content/nature/', 'fauna'],
  'content/religion/',
  'deity',
  'ideology',
  'religion/monotheist',
  'religion/polytheist',
  'science/physical',
  'science/theoretical',
  ['content/government/', 'national'],
  ['content/government/', 'local'],
  'content/history/',
  ['content/language/', 'pseudo'],
  ['content/language/', 'spoken'],
  'content/magic/',
  ['content/location/', 'natural/continent'],
  ['content/location/', 'natural/ecosystem'],
  ['content/location/', 'natural/feature'],
  ['content/location/', 'route/trade'],
  ['content/location/', 'settlement/city'],
  ['content/location/', 'settlement/town'],
  ['content/location/', 'settlement/village'],
  ['content/location/', 'settlement/outpost'],
  ['content/location/', 'settlement/region'],
  ['content/people/', 'historical'],
  ['content/people/', 'notable'],
  ['content/species/', 'beasts'],
  ['content/species/', 'sapient'],
].freeze

def listed_in_index?(page_path, title)
  return true if INDEX_TITLE_RULES.include?(title.to_s.downcase)
  INDEX_PATH_RULES.each do |rule|
    return true if Array(rule).all? { |frag| page_path.to_s.include?(frag) }
  end
  false
end

@failures = []
@warnings = []
@total_words = 0

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
  nil
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
      if line =~ /\[[^\]]*\]\([^)]+\)/ || line =~ /!\[[^\]]*\]\([^)]+\)/
        fail(file, line_no, "links are not allowed in headings")
      end
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
      next if A_BEFORE_VOWEL_RE && base =~ /\A#{A_BEFORE_VOWEL_RE}/i
      fail(file, line_no, "possible article error: 'a #{base}' (use 'an' before vowel)")
    end
    line.scan(/(\b)an\s+([bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ][\w\[\(]*)/) do |_, word|
      base = word.sub(/\A[\[\(]+/, '')
      next if AN_BEFORE_CONSONANT_RE && base =~ /\A#{AN_BEFORE_CONSONANT_RE}/i
      fail(file, line_no, "possible article error: 'an #{base}' (use 'a' before consonant)")
    end
  end

  if headings.empty?
    fail(file, fm_line_offset, "body has no ATX headings")
  else
    opening = headings.first
    if expected && opening[2] != expected
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
  @total_words += words
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

def link_text_excepted?(link_text)
  LINK_TEXT_EXCEPTION_PATTERNS.any? { |re| link_text =~ re }
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
      if !link_text_matches(link_text, title) && !link_text_excepted?(link_text)
        warn(file, abs_line,
             "link text '#{link_text}' for #{url} does not match target page title '#{title}'")
      end
    end
  end
end

CONTENT_FILES = CONTENT_DIR.glob('**/*.md').sort

CONTENT_FILES.each do |f|
  check_file(f)
end

def collect_content_slugs
  CONTENT_DIR.glob('**/*.md').map { |f| f.relative_path_from(CONTENT_DIR).to_s.sub(/\.md\z/, '') }
end

def linked_from_index
  CONTENT_FILES.each_with_object({}) do |f, h|
    rel = f.relative_path_from(ROOT).to_s
    fm_text, _ = parse_front_matter(f.read)
    next if fm_text.nil?
    fm = parse_front_matter_yaml(fm_text)
    h[rel] = fm['title'] if listed_in_index?(rel, fm['title'])
  end
end

all_slugs = collect_content_slugs
linked = linked_from_index
all_slugs.each do |slug|
  unless linked.key?("content/#{slug}.md")
    fail(INDEX_MD, 1, "orphan content page not listed by the homepage index: content/#{slug}")
  end
end

unless @failures.empty?
  puts "Validation failed with #{@failures.length} failure(s):"
  @failures.sort.each { |m| puts "  #{m}" }
end

unless @warnings.empty?
  puts "Warnings (#{@warnings.length}):"
  @warnings.sort.each { |m| puts "  #{m}" }
end

if @failures.empty?
  puts "All checks passed (#{@total_words} words total)."
  exit 0
else
  exit 1
end
