window.user_photos_template = """
    <div class="product-photos">
        {{#product_photos}}
            <div data-url="{{url}}" class="product-photo {{selected}}">
                <img src="{{url}}" alt="{{url}}" />
                <div class="btn {{btnClass}}">
                    <i class="icon-plus-sign"></i>
                    <i class="icon-ok-sign"></i>
                </div>
            </div>
        {{/product_photos}}
    </div>
"""
