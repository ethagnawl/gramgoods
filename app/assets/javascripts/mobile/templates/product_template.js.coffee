templates.product_template = """
    <div
        class="product {{custom_merchant_wrapper_class}}"
        data-instagram-tag="{{product_instagram_tag}}"
        data-product-slug="{{product_slug}}"
        data-store-slug="{{store_slug}}"
        data-user-owns-store="{{user_owns_store}}">

        <div class="product-left">
          <p class="loading">Loading...</p>
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
          <div class="product-link">
            <a href="/{{store_slug}}/{{product_slug}}"></a>
          </div>
        </div>
  </div>
"""
