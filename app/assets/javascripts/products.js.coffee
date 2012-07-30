if gon.page is 'stores_show' or gon.page is 'products_edit' or gon.page is 'products_new'
    $ ->
        ($ '#product_form_wrapper')
            .on 'click', '.product-photo', ->
                ($ @).toggleClass 'selected'
                ($ @).find('.btn').toggleClass('btn-success btn-inverse')

            .on 'submit', 'form', ->
                product_photos = $.map ($ '.product-photo.selected'), (product_photo) ->
                    ($ product_photo).data('url')
                ($ '#product_photos').val(product_photos)

            .on 'change', '.product-unlimited-quantity', ->
                status = if ($ @).prop('checked') then true else false
                ($ '#product_quantity').prop('disabled', status).val('')

            .on 'click', '.refresh-form', -> render_new_product_form({storeSlug: gon.store_slug})
