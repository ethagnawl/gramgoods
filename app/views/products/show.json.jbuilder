json.name @product.name
json.instagram_tags (@product.instagram_tags.map { |instagram_tag| { :name => 'instagram_tag', :value => instagram_tag.instagram_tag}})
json.product_slug @product.slug
json.store_slug @product.store.slug
json.description @product.description
json.price number_with_precision(@product.price, :precision => 2)
json.quantity @product.get_quantity
json.unlimited_quantity @product.unlimited_quantity
json.colors !@product.colors.empty? ? (@product.colors.map { |color| { :name => 'color', :value => color.color }}) : nil
json.sizes !@product.sizes.empty? ? (@product.sizes.map { |size| { :name => 'size', :value => size.size }}) : nil
json.flatrate_shipping_cost !@product.flatrate_shipping_cost.nil? ? number_with_precision(@product.flatrate_shipping_cost, :precision => 2) : nil

json.draft @product.status == 'Draft'
json.active @product.status == 'Active'
json.out_of_stock @product.status == 'Out of Stock'

json.product_photos @product.product_images.map { |product_image| render_user_photo_template(@product, product_image) }

json.store_owner_instagram @product.store.user.authentication.nickname unless @product.store.user.authentication.nil?
json.put true
