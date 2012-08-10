templates.product_photo_template = """
    <div
        data-url="{{url}}"
        data-instagram-id="{{instagram_id}}"
        data-tags="{{tags}}"
        data-thumbnail="{{thumbnail}}"
        data-likes="{{likes}}"
        class="product-photo {{selected}}">

        <img src="{{url}}" />
        <div class="btn {{btnClass}}">
            <i class="icon-plus-sign"></i>
            <i class="icon-ok-sign"></i>
        </div>
    </div>
"""
