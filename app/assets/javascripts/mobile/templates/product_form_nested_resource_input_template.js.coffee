templates.product_form_nested_resource_input_template = """
    <input
        type="hidden"
        name="product[{{name}}s_attributes][{{n}}][{{name}}]"
        value="{{value}}"
        id="{{name}}"
    >
"""
