window.order_form_validation_rules =
    fields:
        '#order_recipient_attributes_first_name':
            message: 'First Name is required.'
            required: true
        '#order_recipient_attributes_last_name':
            message: 'Last Name is required.'
            required: true
        '#order_recipient_attributes_email_address':
            message: 'Email Address is required.'
            required: true
            test: happy.email
        '#order_recipient_attributes_street_address_one':
            message: 'Street Address is required.'
            required: true
        '#order_recipient_attributes_city':
            message: 'City is required.'
            required: true
        '#order_recipient_attributes_state':
            message: 'State is required.'
            required: true
        '#order_recipient_attributes_postal_code':
            message: 'Postal Code is required.'
            required: true
            test: happy.postal_code
        '#order_recipient_attributes_country':
            message: 'Country is required.'
            required: true
        '#credit_card_number':
            message: 'Credit Card Number is required.'
            required: true
            test: happy.credit_card_number
        '#credit_card_expiration_month':
            message: 'Credit Card Expiration Month is required.'
            required: true
        '#credit_card_expiration_year':
            message: 'Credit Card Expiration Year is required.'
            required: true

