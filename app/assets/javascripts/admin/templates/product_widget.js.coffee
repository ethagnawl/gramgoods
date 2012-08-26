templates.product_widget_template = """
    <div
        class="product-widget well"
        data-product_slug='{{product_slug}}'
        data-store_slug='{{store_slug}}'
        data-name='{{name}}'
    >

        <h2 class="product-name" title="{{name}}">{{truncated_name}}</h2>

        {{#product_photo}}
        <div class="product-photo-wrapper">
                <img class='product-photo' src='{{product_photo}}' alt='{{truncated_name}}' />
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

        <p class="product-description" title='{{description}}'>{{truncated_description}}</p>
        <p class="product-instagram-tag">Instagram Tag(s): {{instagram_tags}}</p>
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
            href="/{{store_slug}}/{{product_slug}}?layout=mobile"
            class="btn btn-primary product-preview"
            target='_blank'
        >
            View {{product_slug}}
            <i class="icon-white icon-globe"></i>
        </a>
        <div class="product-photos-gallery {{product_photo_gallery_scroll}}">
            {{#product_photos}}
                <img src="{{url}}" alt="{{name}}" class="product-photos-gallery-photo" />
            {{/product_photos}}
        </div>
    </div>
"""
