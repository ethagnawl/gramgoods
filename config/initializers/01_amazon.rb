AMAZON_CONFIG = {}

if Rails.env.development?
  hash = File.open("#{Rails.root}/config/amazon_config.yml") do |f| YAML::load(f) end
  AMAZON_CONFIG = hash[Rails.env.to_s]
else
  AMAZON_CONFIG['AWS_BUCKET'] = ENV['AWS_BUCKET']
  AMAZON_CONFIG['AWS_ACCESS_KEY_ID'] = ENV['AWS_ACCESS_KEY_ID']
  AMAZON_CONFIG['AWS_SECRET_ACCESS_KEY'] = ENV['AWS_SECRET_ACCESS_KEY']
end

