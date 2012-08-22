$ ->
    window.product_form_options =
        rules:
            'product[name]': 'required'
            'product[description]':
                required: true
                maxlength: 500
            'product[price]':
                required: true
                decimalTwo: true
                range: [0, 999999]
            'product[quantity]':
                digits: true
                range: [0, 999999]
                required: (element) ->
                    !($ '#product_unlimited_quantity').prop('checked')
            'product[flatrate_shipping_cost]':
                decimalTwo: true
                range: [0, 999999]
                required: (element) -> element.value isnt ''

    $.extend(product_form_options, form_options)
