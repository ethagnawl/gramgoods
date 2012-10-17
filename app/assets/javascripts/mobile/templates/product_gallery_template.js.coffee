window.templates = window.templates or {}

templates.product_image_template = """
<img class='product-thumbnail' src='{{product_image}}' alt='{{product_name}}' />
"""

templates.product_thumbnail_gallery_image_template = """
<img src="{{product_image}}" data-index="{{index}}" class="{{classes}}" alt="{{product_name}}">
"""

templates.product_thumbnail_gallery_control_template = """
<a href="javascript: void(0);" data-js-handle='true' data-index="{{index}}" class="{{classes}}"></a>
"""

