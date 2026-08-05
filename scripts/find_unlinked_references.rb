#!/usr/bin/env ruby
# frozen_string_literal: true

# Scans all content pages and reports/applies the first unlinked inline
# reference to each other page, as candidates for denser internal linking.
#
# Usage:
#   ruby scripts/find_unlinked_references.rb --report=FILE
#   ruby scripts/find_unlinked_references.rb --apply
#
# --apply rewrites content files via regex-based text substitution. It is a
# tool for a human to run deliberately and review with `git diff` before
# committing, not something to invoke as unattended automation — see
# agents.md's "do not use scripts to modify content files" guidance.

require 'yaml'
require 'date'

CONTENT_DIR = File.join(__dir__, '..', 'content')
APPLY = ARGV.include?('--apply')
OUTPUT_FILE = ARGV.find { |a| a.start_with?('--report=') }&.split('=', 2)&.last
LINK_RE = /\[[^\]]*\]\([^)]*\)/

def in_heading?(body, pos)
  bol = body.rindex("\n", pos)
  bol = bol ? bol + 1 : 0
  eol = body.index("\n", bol) || body.length
  body[bol...eol].lstrip.start_with?('#')
end

# Returns a copy of body, identical in length and line breaks, with the
# contents of fenced code blocks, indented code blocks, and HTML comments
# replaced by spaces — so title matches never fire inside sample code, and
# byte offsets/line numbers still map 1:1 onto the original body.
def mask_non_prose(body)
  masked = body.gsub(/<!--.*?-->/m) { |m| m.gsub(/[^\n]/, ' ') }

  in_fence = false
  in_indented_block = false
  lines = masked.lines.map do |line|
    if line =~ /\A(\s*)(```|~~~)/
      in_fence = !in_fence
      line.gsub(/[^\n]/, ' ')
    elsif in_fence
      line.gsub(/[^\n]/, ' ')
    elsif line.strip.empty?
      in_indented_block = false
      line
    elsif line =~ /\A(?: {4,}|\t)/
      in_indented_block = true
      line.gsub(/[^\n]/, ' ')
    elsif in_indented_block
      in_indented_block = false
      line
    else
      line
    end
  end

  lines.join
end

# ---------------------------------------------------------------------------
# Step 1 — Gather all pages (title + target path)
# ---------------------------------------------------------------------------

pages = []

Dir.glob(File.join(CONTENT_DIR, '**', '*.md')).sort.each do |abspath|
  raw = File.read(abspath)
  next unless raw =~ /\A---\s*\n(.*?\n)---\s*\n/m

  begin
    meta = YAML.safe_load($1, permitted_classes: [Date])
  rescue => e
    warn "skip #{abspath}: #{e.message}"
    next
  end

  title = meta&.fetch('title', nil) or next
  rel = abspath.sub("#{CONTENT_DIR}/", '')
  link = "/content/#{rel.sub(/\.md\z/, '')}"

  pages << { title:, link:, rel:, abspath: }
end

# ---------------------------------------------------------------------------
# Step 2 — Build case-insensitive lookup (longest title first)
# ---------------------------------------------------------------------------

lookup = {}
pages.each { |p| lookup[p[:title]] = p }

sorted_titles = pages.map { |p| p[:title] }.uniq.sort_by { |t| [-t.length, t] }

# ---------------------------------------------------------------------------
# Step 3 — Detect candidates
# ---------------------------------------------------------------------------

results = [] # [source_rel, line_num, match_text, target_link, target_title]

pages.each do |src|
  body = File.read(src[:abspath])
  body = body.sub(/\A---\s*\n.*?\n---\s*\n/m, '')
  scan_body = mask_non_prose(body)

  link_offsets = body.enum_for(:scan, LINK_RE).map { |m| $~.begin(0)...$~.end(0) }

  sorted_titles.each do |tgt_title|
    next if tgt_title.downcase == src[:title].downcase

    tgt = lookup[tgt_title] or next

    escaped = Regexp.escape(tgt_title)
    re = if tgt_title.include?(' ')
      /#{escaped}/i
    else
      /\b#{escaped}\b/i
    end

    first_candidate = nil

    scan_body.scan(re) do
      matched = $~.to_s
      pos = $~.begin(0)
      next if link_offsets.any? { |r| r.cover?(pos) }
      next if in_heading?(body, pos)
      is_single_word = !tgt_title.include?(' ')
      next if is_single_word && matched !~ /\A[[:upper:]]/
      first_candidate = { match: matched, pos: }
      break
    end

    next unless first_candidate

    line_num = body[0...first_candidate[:pos]].count("\n") + 1
    results << [src[:rel], line_num, first_candidate[:match], tgt[:link], tgt[:title]]
  end
end

# ---------------------------------------------------------------------------
# Step 4 — Apply or Report
# ---------------------------------------------------------------------------

if APPLY
  by_file = results.group_by { |r| r[0] }
  total_links = 0

  by_file.each do |rel, cands|
    abspath = File.join(CONTENT_DIR, rel)
    raw = File.read(abspath)
    frontmatter = raw[/\A---\s*\n.*?\n---\s*\n/m] || ''
    body = raw.sub(/\A---\s*\n.*?\n---\s*\n/m, '')

    cands.sort_by { |c| -c[2].length }.each do |c|
      _, _, match_text, tgt_link, tgt_title = c

      # Recompute against the current (possibly already-edited) body, masking
      # out code/comment regions so replacements never land inside them.
      scan_body = mask_non_prose(body)
      link_offsets = body.enum_for(:scan, LINK_RE).map { |m| $~.begin(0)...$~.end(0) }

      escaped = Regexp.escape(match_text)
      re = match_text.include?(' ') ? /#{escaped}/i : /\b#{escaped}\b/i

      scan_body.scan(re) do
        matched = $~.to_s
        pos = $~.begin(0)
        next if link_offsets.any? { |r| r.cover?(pos) }
        next if in_heading?(body, pos)
        replacement = "[#{matched}](#{tgt_link})"
        body[pos, matched.length] = replacement
        total_links += 1
        break
      end
    end

    File.write(abspath, frontmatter + body)
  end

  puts "Applied #{total_links} links across #{by_file.size} files."

else
  lines = []
  lines << "Unlinked reference candidates (first mention per topic per page)"
  lines << "Total candidates: #{results.length}"
  lines << ""

  current_file = nil
  results.sort_by { |r| [r[0], r[1]] }.each do |rel, line, match_text, tgt_link, tgt_title|
    if rel != current_file
      lines << "content/#{rel}:"
      current_file = rel
    end
    lines << "  L#{line}  \"#{match_text}\" -> #{tgt_link}  (#{tgt_title})"
  end

  output = lines.join("\n")

  if OUTPUT_FILE
    File.write(OUTPUT_FILE, output)
    puts "Report written to #{OUTPUT_FILE}"
    puts "Total candidates: #{results.length}"
  else
    puts output
  end
end
