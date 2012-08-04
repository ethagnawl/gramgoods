window.user_photo_feed_template = """
    <div class="photo-feed">
        {{#product_photos}}
            {{> product_photo}}
        {{/product_photos}}
    </div>
    <a data-max-id='{{max_id}}' class="fetch-more-user-photos" href="javascript:void(0);">Fetch Additional Photos</a>
"""
