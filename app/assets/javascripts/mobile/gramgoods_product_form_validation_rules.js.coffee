window.gramgoods_product_form_validation_rules =
    fields:
        '#fake_product_image_input':
            message: 'At least one product image is required.'
            required: 'sometimes'
            test: ->
                !(_.every(($ '.user-product-image-input').val(), (val) -> val is '') && $('.photo-wrapper.selected').length is 0)

        '#product_name':
            message: 'Product Name is required.'
            required: true
        '#product_description':
            message: 'Description is required.'
            required: true
        '#product_price':
            message: 'Valid price is required. (e.g. 9.99)'
            required: true
            test: (val) -> happy.is_valid_price(val)
        '#product_status':
            message: 'Status is required.'
            required: true
        '#product_quantity':
            message: 'Product Quantity is required.'
            required: 'sometimes'
            test: (val) ->
                if val is ''
                    $('#product_unlimited_quantity').prop('checked')
                else
                    happy.is_valid_quantity(val)

                    # quantity is required if unlimited quantity isn't checked
                    # quantity becomes disabled when unlimited quantity is checked

if gon.flatrate_shipping_options?
    for _flatrate_shipping_option in gon.flatrate_shipping_options
        flatrate_shipping_option = "#product_#{_flatrate_shipping_option}_flatrate_shipping_cost"

        gramgoods_product_form_validation_rules['fields'][flatrate_shipping_option] =
            message: "Valid #{GramGoods.capitalize(_flatrate_shipping_option)} Flatrate Shipping Price is required. (e.g. 9.99)"
            required: 'sometimes'
            test: (val) ->
                if val is ''
                    true
                else
                    happy.is_valid_price(val)
