templates.product_widget_template = """
    <div class="product-widget well" data-product-photos="{{_product_photos}}" data-name='{{name}}' data-raw-instagram-tags='{{raw_instagram_tags}}' data-instagram-tags='{{instagram_tags}}' data-slug='{{slug}}' data-store-slug='{{store_slug}}' data-store-id='{{store_id}}' data-url='{{url}}' data-description='{{description}}' data-price='{{raw_price}}' data-quantity='{{raw_quantity}}' data-unlimited-quantity='{{unlimited_quantity}}' data-colors='{{colors}}' data-sizes='{{sizes}}' data-flatrate-shipping-cost='{{raw_flatrate_shipping_cost}}' data-status='{{status}}' data-draft='{{draft}}' data-active='{{active}}' data-out-of-stock='{{out_of_stock}}' data-raw-product-photo-count='{{raw_product_photo_count}}' data-thumbnail='{{thumbnail}}' data-store_owner_instagram='{{store_owner_instagram}}' data-store_owner_email='{{store_owner_email}}'>
        <h2 class="product-name">{{truncated_name}}</h2>

        {{#product_photo}}
        <div class="product-photo-wrapper">
                <img class='product-photo' src='{{product_photo}}' alt='{{name}}' />
            <span class="product-photo-count" title='click to see product photos'>
                {{product_photo_count}}
                <i class='icon-zoom-in'></i>
                <i class='icon-zoom-out'></i>
            </span>
        </div>
        {{/product_photo}}

        {{^product_photo}}
        <div class="product-photo-warning widget">
            <p class='widget'>
                IMPORTANT: This product has no photos associated with it.
            </p>
            <p class='widget'>
                Once your photo(s) have been posted to Instagram...
            </p>
            <ol class='widget'>
                <li>Click the "Edit" button in the top-right corner of this card.</li>
                <li>Select photos from your Instagram feed you'd like to associate with this product.</li>
                <li>Change this product's "Status" to "Active".</li>
                <li>Click "Update Product".</li>
            </ol>
        </div>
        {{/product_photo}}

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
        <p class="product-status">
            Status: <span class='label label-{{_status}}'>{{status}}</span>
        </p>
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
