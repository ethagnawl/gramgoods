class Symbol
  def titleize
    self.to_s.titleize
  end
end

if !ENV["MERCHANTS_WITH_CUSTOM_STORE_SLUGS_CSV"].nil?
  MERCHANTS_WITH_CUSTOM_STORE_SLUGS = ENV["MERCHANTS_WITH_CUSTOM_STORE_SLUGS_CSV"].split(',')
else
  MERCHANTS_WITH_CUSTOM_STORE_SLUGS = ['wink']
end

if !ENV["PRODUCT_PAGINATION_SIZE"].nil?
  PRODUCT_PAGINATION_SIZE = ENV["PRODUCT_PAGINATION_SIZE"].to_i
else
  PRODUCT_PAGINATION_SIZE = 5
end

if ENV["DEBUG"].nil?
    DEBUG = false
else
    DEBUG = (ENV['DEBUG'].to_s == 'true') ? true : false
end

S3_BUCKET = ENV['FOG_DIRECTORY'] || 'gramgoods-development-assets'

ADMIN_EMAIL_ADDRESS = ENV['ADMIN_EMAIL'] || 'admin@gramgoods.com'

require 'gram_goods/instagram'
