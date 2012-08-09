$ ->
    window.store_form_options =
        rules:
            'store[name]':
                required: true
                maxlength: 30
            'store[return_policy]':
                required: true
                maxlength: 500

    $.extend(store_form_options, form_options)
