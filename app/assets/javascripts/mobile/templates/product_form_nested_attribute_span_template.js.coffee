templates.product_form_nested_attribute_span_template = """
    <span class='attribute-wrapper label' id='{{n}}'>
        {{value}}
        <a class='remove-attribute'
           href='javascript: void(0);'
           data-js-handle='true'
           data-attribute='{{value}}'
           data-id='{{n}}'
           >
               <i class='icon-remove-sign'></i>
        </a>
        {{> hidden_input_template}}
    </span>
"""
