Gramgoods::Application.configure do

  if Rails.env.development?
    hash = File.open("#{Rails.root}/config/amazon_config.yml") do |f| YAML::load(f) end
    AMAZON_CONFIG = hash[Rails.env.to_s]
  else
    AMAZON_CONFIG = {}
    AMAZON_CONFIG['AWS_BUCKET'] = ENV['AWS_BUCKET']
    AMAZON_CONFIG['AWS_ACCESS_KEY_ID'] = ENV['AWS_ACCESS_KEY_ID']
    AMAZON_CONFIG['AWS_SECRET_ACCESS_KEY'] = ENV['AWS_SECRET_ACCESS_KEY']
  end

  # Paperclip config after AMAZON_CONFIG has been set
  Paperclip.options[:command_path] = "/usr/local/bin"
  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => AMAZON_CONFIG['AWS_BUCKET'],
      :access_key_id => AMAZON_CONFIG['AWS_ACCESS_KEY_ID'],
      :secret_access_key => AMAZON_CONFIG['AWS_SECRET_ACCESS_KEY']
    }
  }
end
