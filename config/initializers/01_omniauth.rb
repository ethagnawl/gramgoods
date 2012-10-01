OmniAuth.config.logger = Rails.logger

if defined?(INSTAGRAM_CONFIG)
  #nothing to do
elsif (!ENV["INSTAGRAM_ID"].nil? && !ENV["INSTAGRAM_SECRET"].nil?)
  INSTAGRAM_CONFIG = {
    'id' => ENV['INSTAGRAM_ID'],
    'secret' => ENV['INSTAGRAM_SECRET']
  }
else
  require 'yaml'
  hash = File.open("#{Rails.root}/config/instagram.yml") do |f| YAML::load(f) end
  INSTAGRAM_CONFIG = hash[Rails.env.to_s]
end
