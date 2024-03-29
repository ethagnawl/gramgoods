templates.existing_photo_grid_photos_template = """
    {{>existing_photo_grid_photo_template}}
"""

templates.existing_photo_grid_photo_template = """
    {{#product_images}}
        <div class='photo-wrapper' data-url='{{product_image}}'>
            <img src="{{product_image}}" class="photo">
            <span class='remove btn btn-success'>
                <i class='icon-ok'></i>
            </span>
            <span class='add btn'>
                <i class='icon-plus-sign'></i>
            </span>
        </div>
    {{/product_images}}
"""

