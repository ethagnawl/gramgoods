window.templates = {}

if gon.page is 'stores_show' or gon.page is 'products_show'
    dirty_commas = (num) ->
        String(num).replace /^\d+(?=\.|$)/, (int) ->
            int.replace /(?=(?:\d{3})+$)(?!^)/g, ','

    Zepto ($) ->
        # fixes iOS sticky fixed position bug
        # when navigating from stores/show to
        # products/show the header would stick
        # at the position it was set to at page unload
        header_fix = -> scrollTo(0, 0)

        if gon.page is 'stores_show'
            header_fix()

            ($ '.products').on('tap', '.product', ->
                destination = ($ @).find('.product-link > a').attr('href')
                location.href = destination)

        if gon.page is 'products_show'
            header_fix()

            # only reveal product gallery controls if there
            # is more than one product image
            if ($ '.product-gallery-control').length > 1
                $('.product-gallery-controls')
                    .css('width', $('.product-gallery-controls').width())
                    .removeClass('invisible').addClass('display-block')

            ($ '.product-thumbnail').swipeLeft ->
                next_index = ($ @).next().data('index')
                if next_index?
                    ($ @).addClass('hide')
                    ($ @).next().removeClass('hide')
                    ($ '.product-gallery-control.on')
                        .removeClass('on').next().addClass('on')

            ($ '.product-thumbnail').swipeRight ->
                previous_index = ($ @).prev().data('index')
                if previous_index?
                    ($ @).addClass('hide')
                    ($ @).prev().removeClass('hide')
                    ($ '.product-gallery-control.on')
                        .removeClass('on').prev().addClass('on')

            # setTimeout is required because
            # tap was clicking the purchase
            # link after scrollTo
            ($ '.product-details').tap ->
                setTimeout =>
                    scrollTo 0, ($ @).offset().top - 56
                , 100

            redirect_to_order_form = ->
                data =
                    product_id: gon.product_id
                    quantity: (+($.trim(($ '#quantity').val()))) or 1
                if ($ '#color').length > 0
                    data.color = $.trim(($ '#color').val())
                if ($ '#size').length > 0
                    data.size = $.trim(($ '#size').val())
                if gon.layout is 'mobile'
                    data.layout = 'mobile'

                window.location = "#{gon.create_order_url}?#{$.param(data)}"

            ($ '#redirect_to_order_form').tap -> redirect_to_order_form()

            # for desktop users
            ($ '#redirect_to_order_form').click (e) -> redirect_to_order_form()

if gon.page is 'orders_new' or gon.page is 'orders_edit' or gon.page is 'orders_create'
    stripeResponseHandler = (status, response) ->
        if response.error
            alert response.error.message
        else
            token = response['id']
            $(".order-form")
                .append("<input type='hidden' name='stripeToken' value='#{token}'/>")
                .get(0)
                    .submit()

    $ ->
        ($ "#order_form")
            .submit((e) ->
                e.preventDefault()
                Stripe.createToken({
                    number: $('#credit_card_number').val(),
                    exp_month: $('#credit_card_expiration_month').val(),
                    exp_year: $('#credit_card_expiration_year').val()
                }, stripeResponseHandler))
            .isHappy
                # TODO move into rules file
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

