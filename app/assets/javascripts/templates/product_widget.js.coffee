window.product_widget_template = """
    <div class="product-widget well" data-name='{{name}}' data-instagram-tag='{{instagram_tag}}' data-slug='{{slug}}' data-store-slug='{{store_slug}}' data-store-id='{{store_id}}' data-url='{{url}}' data-description='{{description}}' data-price='{{raw_price}}' data-quantity='{{raw_quantity}}' data-unlimited-quantity='{{unlimited_quantity}}' data-colors='{{colors}}' data-sizes='{{sizes}}' data-flatrate-shipping-cost='{{raw_flatrate_shipping_cost}}' data-status='{{status}}' data-draft='{{draft}}' data-active='{{active}}' data-out-of-stock='{{out_of_stock}}'>
        <h2 class="product-name">
          <a href="{{url}}">{{truncated_name}}</a>
        </h2>
        <div class="product-image-wrapper">
            <img src='{{product_photo}}' alt='{{name}}' />
            <span class="product-count">{{product_count}}</span>
        </div>
        <p class="product-description">{{description}}</p>
        <p class="product-instagram-tag">Instagram Tag: \#{{instagram_tag}}</p>
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
        <p class="product-status">Status: {{status}}</p>
        <a title="Edit {{name}}" class="gramgoods-tooltip edit-product" href="javascript: void(0);"><i class="icon-cog"></i>
        <a title='Delete {{name}}' class='gramgoods-tooltip delete-product' href="javascript: void(0);"><i class='icon-remove-sign'></i></a>
        </a>
    </div>
"""
