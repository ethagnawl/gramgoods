templates.product_widget_template = """
    <div class="product-widget well" data-product-photos="{{_product_photos}}" data-name='{{name}}' data-raw-instagram-tags='{{raw_instagram_tags}}' data-instagram-tags='{{instagram_tags}}' data-slug='{{slug}}' data-store-slug='{{store_slug}}' data-store-id='{{store_id}}' data-url='{{url}}' data-description='{{description}}' data-price='{{raw_price}}' data-quantity='{{raw_quantity}}' data-unlimited-quantity='{{unlimited_quantity}}' data-colors='{{colors}}' data-sizes='{{sizes}}' data-flatrate-shipping-cost='{{raw_flatrate_shipping_cost}}' data-status='{{status}}' data-draft='{{draft}}' data-active='{{active}}' data-out-of-stock='{{out_of_stock}}' data-raw-product-photo-count='{{raw_product_photo_count}}' data-thumbnail='{{thumbnail}}'>
        <h2 class="product-name">{{truncated_name}}</h2>
        <div class="product-image-wrapper">
            {{#product_photo}}
                <img class='product-photo' src='{{product_photo}}' alt='{{name}}' />
            {{/product_photo}}
            <span class="product-photo-count" title='click to see product photos'>
                {{product_photo_count}}
                <i class='icon-zoom-in'></i>
                <i class='icon-zoom-out'></i>
            </span>
        </div>
        <p class="product-description">{{description}}</p>
        <p class="product-instagram-tag">Instagram Tag(s): {{raw_instagram_tags}}</p>
        <p class="product-price">Price: {{price}}</p>
        <p class="product-quantity">Quantity: {{quantity}}</p>
        {{#flatrate_shipping_cost}}
        <p class="product-shipping">Flat Rate Shipping: {{flatrate_shipping_cost}}</p>
        {{/flatrate_shipping_cost}}
        {{#colors}}
        <p class="product-colors">Colors: {{colors}}</p>
        {{/colors}}
        {{#sizes}}
        <p class="product-sizes">Sizes: {{sizes}}</p>
        {{/sizes}}
        <p class="product-status">Status: <span class='{{_status}}'>{{status}}</span></p>
        <a title="Edit {{name}}" class="gramgoods-tooltip edit-product" href="javascript: void(0);"><i class="icon-cog"></i></a>
        <a title='Delete {{name}}' class='gramgoods-tooltip delete-product' href="javascript: void(0);"><i class='icon-remove-sign'></i></a>
        <a
            href="/{{store_slug}}/{{slug}}?layout=mobile"
            class="btn btn-primary product-preview"
            target='_blank'
        >
            View {{slug}}
            <i class="icon-white icon-globe"></i>
        </a>
        <div class="product-photos-gallery {{product_photo_gallery_scroll}}">
            {{#product_photos}}
                <img src="{{url}}" alt="{{name}}" class="product-photos-gallery-photo" />
            {{/product_photos}}
        </div>
    </div>
"""
