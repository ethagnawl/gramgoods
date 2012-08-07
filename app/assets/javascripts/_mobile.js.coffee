# fixes iOS sticky fixed position bug
# when navigating from stores/show to
# products/show the header would stick
# at the position it was set to at page unload
scrollTo(0, 0)

if gon.page is 'stores_show' and gon.user_signed_in isnt true
    navigate_to = (store_slug, product_slug) ->
        window.location.href = window.location.origin + '/' + store_slug + '/' + product_slug

    ($ '.product').tap -> navigate_to(gon.store_slug, ($ @).data('slug'))

if gon.page is 'products_show' and gon.user_signed_in isnt true
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

