window.store_form_validation_rules =
    fields:
        '#user_email':
            message: 'Email Address is required.'
            required: true
            test: happy.email
        '#store_name':
            message: 'Store Name is required.'
            required: true
        '#store_return_policy':
            message: 'Store Return Policy is required.'
            required: true
        '#store_terms_of_service':
            message: 'You must agree to the GramGoods Terms of Service.'
            required: true
            test: happy.is_checked
            arg: '#store_terms_of_service'

