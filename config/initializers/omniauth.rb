if defined?(INSTAGRAM_CONFIG)
  #nothing to do
elsif (!ENV["BUCKET_NAME"].nil? && !ENV["BUCKET"].nil? && !ENV["ACCESS_KEY_ID"].nil? && !ENV["SECRET_ACCESS_KEY"].nil?)
  S3_CONFIG = {
    "bucket" => ENV["BUCKET"],
    "access_key_id" => ENV["ACCESS_KEY_ID"],
    "secret_access_key" => ENV["SECRET_ACCESS_KEY"]}
else
  require 'yaml'
  hash = File.open("#{Rails.root}/config/instagram.yml") do |f| YAML::load(f) end
  INSTAGRAM_CONFIG = hash[Rails.env.to_s]
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :instagram, INSTAGRAM_CONFIG['id'], INSTAGRAM_CONFIG['secret']
end

