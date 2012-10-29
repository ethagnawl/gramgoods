class Symbol
  def titleize
    self.to_s.titleize
  end
end

if !ENV["MERCHANTS_WITH_CUSTOM_STORE_SLUGS_CSV"].nil?
  MERCHANTS_WITH_CUSTOM_STORE_SLUGS = ENV["MERCHANTS_WITH_CUSTOM_STORE_SLUGS_CSV"].split(',')
else
  MERCHANTS_WITH_CUSTOM_STORE_SLUGS = ['my-sample-store']
end

