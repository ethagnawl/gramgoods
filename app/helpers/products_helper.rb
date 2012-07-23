module ProductsHelper
  def product_photo_url(product)
    product['images']['standard_resolution']['url']
  end
end
