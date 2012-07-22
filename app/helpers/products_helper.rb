module ProductsHelper
  def product_photo_url(product)
    product['images']['thumbnail']['url']
  end
end
