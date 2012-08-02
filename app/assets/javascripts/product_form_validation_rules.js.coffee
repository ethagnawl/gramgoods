$ ->
    window.product_form_options =
        rules:
            'product[name]': 'required'
            'product[instagram_tag]': 'required'
            'product[description]': 'required'
            'product[price]':
                required: true
                number: true
            'product[quantity]':
                required: true
                digits: true
            # flatrate_shipping number true if !empty
            # quantity not required if unlimited is on
    $.extend(product_form_options, form_options)
