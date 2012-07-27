window.product_widget_template = """
    <div class="product-widget well">
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
        <a title="Edit {{name}}" class="edit-product" href="{{url}}/edit"><i class="icon-cog"></i>
        </a>
    </div>
"""
