require 'socket'

def local_site_url
  addresses = Socket.getifaddrs.map(&:addr).compact.select do |address|
    address.ipv4? && !address.ipv4_loopback?
  end.map(&:ip_address)
  private_address = addresses.find { |address| address.start_with?('192.168.') }
  private_address ||= addresses.find do |address|
    address.start_with?('10.') || address.match?(/\A172\.(1[6-9]|2\d|3[01])\./)
  end
  private_address ||= '127.0.0.1'
  "http://#{private_address}:#{ENV.fetch('JEKYLL_PORT', '4000')}"
end

Jekyll::Hooks.register :site, :after_init do |site|
  production_url = ENV['JEKYLL_SITE_URL']
  if production_url && !production_url.empty?
    production_url = production_url.chomp('/')
    site.config['url'] = production_url
    site.config['site_url'] = production_url
  elsif Jekyll.env != 'production' && site.config['site_url'] == site.config['url']
    local_url = local_site_url
    site.config['url'] = local_url
    site.config['site_url'] = local_url
  end
end
