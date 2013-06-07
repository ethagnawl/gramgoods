window.store_form_validation_rules =
    fields:
        '#user_business_name':
            message: 'Business Name is required.'
            required: true
        '#user_first_name':
            message: 'First Name is required.'
            required: true
        '#user_last_name':
            message: 'Last Name is required.'
            required: true
        '#user_email':
            message: 'Email Address is required.'
            required: true
            test: happy.email
        '#user_phone_number':
            message: 'Phone Number is required.'
            required: true
        '#user_street_address_1':
            message: 'Street Address is required.'
            required: true
        '#user_city':
            message: 'City is required.'
            required: true
        '#user_state':
            message: 'State is required.'
            required: true
        '#user_postal_code':
            message: 'Postal Code is required.'
            required: true
            test: happy.postal_code
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

