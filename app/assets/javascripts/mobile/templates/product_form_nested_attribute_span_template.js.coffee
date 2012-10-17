templates.product_form_nested_attribute_span_template = """
    <span class='attribute-wrapper' id='{{n}}'>
        {{value}}
        <a class='remove-attribute'
           href='javascript: void(0);'
           data-js-handle='true'
           data-attribute='{{value}}'
           data-id='{{n}}'
           >x</a>
        {{> hidden_input_template}}
    </span>
"""
