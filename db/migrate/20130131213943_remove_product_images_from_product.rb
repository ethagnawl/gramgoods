class RemoveProductImagesFromProduct < ActiveRecord::Migration
  def change
    Product.all.find_all { |p| !p.product_images.nil? }.each do |product|
      product.get_product_images.each do |product_image|
        product.instagram_product_images.create(url: product_image)
      end
    end
    remove_column :products, :product_images
  end
end
