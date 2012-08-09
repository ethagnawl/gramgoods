$ ->
    window.user_form_options =
        rules:
            'user[email]':
                required: true
                email: true
                maxlength: 250
            'user[password]':
                required: true
                maxlength: 16
            'user[password_confirmation]':
                required: true
                maxlength: 16
                equalTo: '#user_password'
            'user[business_name]':
                required: true
                maxlength: 250
            'user[website]':
                required: true
                maxlength: 250
                url: true
            'user[first_name]':
                required: true
                maxlength: 30
            'user[last_name]':
                required: true
                maxlength: 30
            'user[phone_number]':
                required: true
                phoneUS: true
                maxlength: 30
            'user[street_address_1]':
                required: true
                maxlength: 250
            'user[street_address_2]':
                maxlength: 250
            'user[city]':
                required: true
                maxlength: 250
            'user[state]':
                required: true
            'user[postal_code]':
                required: true
                postalCode: true
                maxlength: 16

    $.extend(user_form_options, form_options)
