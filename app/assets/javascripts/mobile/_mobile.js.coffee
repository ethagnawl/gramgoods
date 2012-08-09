if (gon.page is 'stores_show' or gon.page is 'products_show') and gon.user_signed_in isnt true
    window.templates = {}

    Zepto ($) ->
        # fixes iOS sticky fixed position bug
        # when navigating from stores/show to
        # products/show the header would stick
        # at the position it was set to at page unload
        header_fix = -> scrollTo(0, 0)

        if gon.page is 'stores_show' and gon.user_signed_in isnt true
            header_fix()
            navigate_to = (store_slug, product_slug) ->
                window.location.href = window.location.origin + '/' + store_slug + '/' + product_slug

            ($ '.product').tap -> navigate_to(gon.store_slug, ($ @).data('slug'))

        if gon.page is 'products_show' and gon.user_signed_in isnt true
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
                ($ "##{form_id}")
                    .removeClass('hide')
                    .html(Mustache.render(templates["#{form_id}_template"], {}))

            ($ '.product-price').tap -> show_form('address_form')

            ($ document)
                .on('tap', '.hide-form', ->
                    hide_form(($ @).closest('form').attr('id')))

                .on('submit', '.address-form', (e) ->
                    e.preventDefault()
                    hide_form('address_form')
                    show_form('billing_form'))

                .on('submit', '.billing-form', (e) ->
                    e.preventDefault()
                    hide_form('billing_form')
                    alert('cha-ching'))

