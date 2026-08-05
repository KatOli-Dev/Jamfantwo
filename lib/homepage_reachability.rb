require 'yaml'

# Determines which pages under content/ are reachable by following links
# from the homepage, so scripts/validate_content.rb doesn't need to
# hand-maintain a parallel list of "which categories exist".
#
# Reachability rests on two things working together:
#   - _data/navigation.yml, which _includes/nav-home.html renders directly
#     on index.md — this is the actual, single set of entry points into
#     content/ that a reader can click from the homepage.
#   - _plugins/generate_category_indices.rb, which walks the content/ tree
#     and builds a chain of (real or generated) index pages linking every
#     page nested under a directory back up to that directory.
#
# So a page is reachable if it *is* a linked target itself (a standalone
# top-level page like content/geography.md), or if it lives anywhere in
# the subtree under a linked directory (e.g. content/species/) — the
# generator guarantees an index chain covers everything below that point.
module HomepageReachability
  def self.linked_targets(root)
    nav_path = root.join('_data', 'navigation.yml')
    return [] unless nav_path.exist?

    data = YAML.load_file(nav_path) || {}
    urls = (data['groups'] || []).flat_map { |g| (g['items'] || []).map { |i| i['url'] } }
    urls.compact.map { |u| u.to_s.sub(%r{\A/}, '').sub(%r{/\z}, '') }
  end

  # content_relative_path is a path like "content/species/sapient/humans.md",
  # relative to the project root.
  def self.reachable?(root, content_relative_path)
    linked_targets(root).any? do |target|
      content_relative_path == "#{target}.md" || content_relative_path.start_with?("#{target}/")
    end
  end
end
