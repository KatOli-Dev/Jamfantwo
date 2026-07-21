#!/usr/bin/env ruby
require 'pathname'

ROOT = Pathname.new(File.expand_path('..', __dir__))
CONTENT_DIR = ROOT.join('content')

TITLE_RE = /\Atitle:(\s+)The\s+/

updated = 0
scanned = 0

CONTENT_DIR.glob('**/*.md').sort.each do |file|
  scanned += 1
  original = file.read
  lines = original.lines

  if lines.empty? || lines.first.strip != '---'
    next
  end

  end_idx = nil
  lines.each_with_index do |line, idx|
    next if idx == 0
    if line.strip == '---'
      end_idx = idx
      break
    end
  end

  if end_idx.nil?
    next
  end

  changed = false
  front_matter = lines[1...end_idx]
  front_matter = front_matter.each_with_index.map do |line, idx|
    if line =~ TITLE_RE
      changed = true
      line.sub(TITLE_RE, 'title:\1')
    else
      line
    end
  end

  unless changed
    next
  end

  new_text = ([lines.first] + front_matter + lines[end_idx..] || []).join
  file.write(new_text)
  rel = file.relative_path_from(ROOT).to_s
  new_title = front_matter.find { |l| l.start_with?('title:') }.to_s.sub(/\Atitle:\s*/, '').chomp
  puts "  #{rel} -> #{new_title.inspect}"
  updated += 1
end

puts "Scanned #{scanned} files; stripped leading 'The ' from #{updated} title(s)."
