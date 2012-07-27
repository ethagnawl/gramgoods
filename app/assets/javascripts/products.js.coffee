if gon.page is 'stores_show' or gon.page is 'products_edit' or gon.page is 'products_new'
    ($ '.product-photo').on 'click', ->
        ($ @).toggleClass 'selected'
        ($ @).find('.btn').toggleClass('btn-success btn-inverse')

    ($ 'form').on 'submit', (e) ->
        product_photos = $.map ($ '.product-photo.selected'), (product_photo) ->
            ($ product_photo).data('url')
        ($ '#product_photos').val(product_photos)

    $('#product_unlimited_quantity').change (e)->
        status = if ($ @).prop('checked') then true else false
        ($ '#product_quantity').prop('disabled', status)
