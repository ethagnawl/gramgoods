$ ->
    window.product_form_options =
        rules:
            'product[name]': 'required'
            'product[description]':
                required: true
                maxlength: 500
            'product[price]':
                required: true
                number: true
            'product[quantity]':
                required: true
                digits: true
            # flatrate_shipping number true if !empty
            # quantity not required if unlimited is on
    $.extend(product_form_options, form_options)
