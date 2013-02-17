window.external_product_form_validation_rules =
    fields:
        '#fake_product_image_input':
            message: 'At least one product image is required.'
            required: 'sometimes'
            test: ->
                !(_.every(($ '.user-product-image-input').val(), (val) -> val is '') && $('.photo-wrapper.selected').length is 0)

        '#product_name':
            message: 'Product Name is required.'
            required: true
        '#product_price':
            message: 'Valid price is required. (e.g. 9.99)'
            required: true
            test: (val) -> happy.is_valid_price(val)
        '#product_external_url':
            message: 'Valid external URL is required.'
            required: 'sometimes'
            test: (val) -> happy.is_valid_url(val)
