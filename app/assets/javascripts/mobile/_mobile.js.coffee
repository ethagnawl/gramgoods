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
            navigate_to = (store_slug, product_slug) ->
                window.location.href = window.location.origin + '/' + store_slug + '/' + product_slug

            ($ '.product').tap -> navigate_to(gon.store_slug, ($ @).data('slug'))

        if gon.page is 'products_show'
            header_fix()
            $('.product-gallery-controls').css('width', $('.product-gallery-controls').width()).removeClass('invisible').addClass('display-block')
            ($ '.product-thumbnail').swipeLeft ->
                next_index = ($ @).next().data('index')
                if next_index?
                    ($ @).addClass('hide')
                    ($ @).next().removeClass('hide')
                    ($ '.product-gallery-control.on').removeClass('on').next().addClass('on')

            ($ '.product-thumbnail').swipeRight ->
                previous_index = ($ @).prev().data('index')
                if previous_index?
                    ($ @).addClass('hide')
                    ($ @).prev().removeClass('hide')
                    ($ '.product-gallery-control.on').removeClass('on').prev().addClass('on')

            ($ '.product-gallery-control').click ->
                index = ($ @).data('index')
                ($ '.product-gallery-control.on').removeClass('on')
                ($ @).addClass('on')
                ($ '.product-thumbnail.on').addClass('hide').removeClass('on')
                ($ ".product-thumbnail[data-index='#{index}']").removeClass('hide').addClass('on')

            hide_form = (form_id) -> ($ "##{form_id}").addClass('hide').empty()
            show_form = (form_id) ->
                data =
                    product_name: gon.product_name
                    quantity: (+($.trim(($ '#quantity').val()))) or 1
                    color: $.trim(($ '#color').val())
                    size: $.trim(($ '#size').val())
                    flatrate_shipping_cost: +($('#flatrate_shipping_cost').data('flatrate-shipping-cost'))
                    price: +(parseFloat(gon.price).toFixed(2))
                    total: +(parseFloat(gon.price).toFixed(2))

                if data.quantity > 1
                    data.total = data.price * data.quantity

                if data.flatrate_shipping_cost?
                    data.total = data.total + data.flatrate_shipping_cost

                ($ "##{form_id}")
                    .removeClass('hide')
                    .html(Mustache.render(templates["#{form_id}_template"], data))

            ($ '.product-price').tap -> scrollTo 0, ($ @).offset().top - 56

            ($ '#show_order_form').tap ->
                header_fix()
                # avoid taps on newly rendered elements
                setTimeout ->
                    show_form('order_form')
                , 110

            stripeResponseHandler = (status, response) ->
                if response.error
                    alert response.error.message
                else
                    form$ = $(".order-form")
                    token = response['id']
                    form$.append("<input type='hidden' name='stripeToken' value='" + token + "'/>")
                    submit_order_form(form$.serialize())

            ($ document)
                .on('tap', '.edit-quantity', ->
                    hide_form('order_form')
                    scrollTo(0, ($ '#quantity').offset().top))
                .on('tap', '.edit-color', ->
                    hide_form('order_form')
                    scrollTo(0, ($ '#color').offset().top))
                .on('tap', '.edit-size', ->
                    hide_form('order_form')
                    scrollTo(0, ($ '#size').offset().top))
                .on('tap', '.hide-form', ->
                    hide_form(($ @).closest('form').attr('id')))

                .on('submit', '.order-form', (e) ->
                    e.preventDefault()
                    Stripe.createToken({
                        number: $('#credit_card_number').val(),
                        exp_month: $('#credit_card_expiration_month').val(),
                        exp_year: $('#credit_card_expiration_year').val()
                    }, stripeResponseHandler)

                submit_order_form = (data) ->
                    $.post("/stores/#{gon.store_slug}/orders", data, (response) ->
                        response_json = JSON.parse response # why the hell is this necessary?
                        if response_json.status is 'success'
                            hide_form('order_form')
                            ($ 'body').html(
                                Mustache.render(
                                    templates.order_success_template, {}))
                        else
                            alert 'Something went wrong...'))
