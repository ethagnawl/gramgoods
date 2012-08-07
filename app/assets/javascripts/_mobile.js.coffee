navigate_to = (store_slug, product_slug) ->
    window.location = window.location.origin + '/' + store_slug + '/' + product_slug
($ '.product').tap ->
    navigate_to(gon.store_slug, ($ @).data('slug'))
