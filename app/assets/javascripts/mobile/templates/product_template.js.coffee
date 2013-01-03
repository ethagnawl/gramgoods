templates.product_template = """
    <div
        class="product {{custom_merchant_wrapper_class}}"
        data-instagram-tag="{{product_instagram_tag}}"
        data-product-slug="{{product_slug}}"
        data-store-slug="{{store_slug}}"
        data-user-owns-store="{{user_owns_store}}">

        <div class="product-left">
          <img class='product-thumbnail' src='{{product_image}}' alt='{{product_name}}' />
        </div>
        <div class="product-middle">
          <div class="product-name">
            <div class="mobile-wrapper">
                {{product_name}}
            </div>
            <div class="desktop-wrapper">
              <a href="/{{store_slug}}/{{product_slug}}" title="{{product_name}}">
                {{product_name}}
              </a>
            </div>
          </div>
          <div class="store-name">
            <div class="mobile-wrapper">
              {{store_name}}
            </div>
            <div class="desktop-wrapper">
              <a href="/{{store_slug}}" title="{{store_name}}">
                {{store_name}}
              </a>
            </div>
          </div>
          <div class="product-button product-price">
            {{product_price}}
          </div>
          <div class="product-like-count hide"></div>
        </div>
        <div class="product-right">

            <div class="product-link {{#user_owns_store}}hide{{/user_owns_store}}">
                <a href="/{{store_slug}}/{{product_slug}}"></a>
            </div>

            {{#user_owns_store}}
                <div class="owner-action">
                    <a href="/{{store_slug}}/{{product_slug}}" class="btn btn-primary btn-primary">View</a>
                </div>
                <div class="owner-action">
                    <a href="/{{store_slug}}/{{product_slug}}/edit" class="btn btn-primary btn-primary">Edit</a>
                </div>
                <div class="owner-action">
                    <a href="/stores/{{store_slug}}/products/{{product_slug}}" class="btn btn-primary btn-primary" data-confirm="Are you sure you want to delete {{product_name}}?" data-method="delete" rel="nofollow">Delete</a>
                </div>
                <div class="owner-action">
                    <div class="btn btn-primary btn-success" disabled="disabled">
                        {{product_status}}
                    </div>
                </div>
            {{/user_owns_store}}
        </div>
  </div>
"""
