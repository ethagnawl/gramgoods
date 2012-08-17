if (!ENV["STRIPE_API_KEY"].nil? && !ENV["STRIPE_PUBLIC_KEY"].nil?)
  STRIPE_CONFIG = {
    "API_KEY" => ENV["STRIPE_API_KEY"],
    "PUBLIC_KEY" => ENV["STRIPE_PUBLIC_KEY"]
  }
else
  require 'yaml'
  hash = File.open("config/stripe_config.yml") do |f| YAML::load(f) end
  STRIPE_CONFIG = hash[Rails.env.to_s]
end

Stripe.api_key = STRIPE_CONFIG['API_KEY']
