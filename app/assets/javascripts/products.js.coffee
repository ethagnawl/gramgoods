($ '.product-photo').on 'click', ->
    ($ @).toggleClass 'selected'

($ '.product-form').on 'submit', (e) ->
    product_photos = $.map ($ '.product-photo.selected'), (product_photo) ->
        ($ product_photo).data('url')
    ($ '#product_photos').val(product_photos)
