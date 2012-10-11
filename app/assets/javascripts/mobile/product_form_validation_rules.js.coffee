window.product_form_validation_rules =
    fields:
        '#product_name':
            message: 'Product Name is required.'
            required: true
        '#product_instagram_tag_attributes_instagram_tag':
            message: 'Instagram Tag is required.'
            required: true
        '#product_description':
            message: 'Description is required.'
            required: true
        '#product_price':
            message: 'Price is required.'
            required: true
            test: happy.is_price
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
