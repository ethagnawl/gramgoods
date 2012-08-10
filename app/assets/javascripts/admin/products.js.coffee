if gon.page is 'stores_show' or gon.page is 'products_edit' or gon.page is 'products_new'
    #config
    product_photos_gallery_displayed = 'product-photos-gallery-displayed'

    # build csv of label data
    # i.e. size: small,medium,large
    map_label_values = (name) -> $.map(($ ".label-#{name}"), (e) ->
        ($ e).data('value')).join(',')

    # hide open product-widget photo galleries
    reset_product_photo_galleries = ->
        ($ ".#{product_photos_gallery_displayed}").each ->
            ($ @).removeClass(product_photos_gallery_displayed)

    # select product photo for inclusion
    window.select_photo = ($el) ->
        $el.toggleClass('selected')
        $el.find('.btn').toggleClass('btn-success btn-inverse')

    $ ->
        $product_form_wrapper
            .on 'click', '.product-photo', ->
                select_photo(($ @))

            .on 'click', '.fetch-more-user-photos', ->
                fetch_user_photos(update_user_photos, {max_id: ($ @).data('maxId')})

            .on 'submit', 'form', ->

                # construct fields_for product_images
                # comprised of photos that are already associated
                # with the product, have been selected (clicked)
                # by the user or by the .add-instagram-tag feature
                container = $('<div />').attr('class', 'hide')
                ($ '.product-photo.selected').each (i, product_photo) ->
                    data = ($ product_photo).data()
                    container.append(
                        Mustache.render(templates.product_image_form_field,
                            url: data.url
                            tags: data.tags
                            thumbnail: data.thumbnail
                            instagram_id: data.instagramId
                            product_image_n: i))
                ($ @).append(container)

                # query instagram tag, color and sizes labels and
                # update appropriate input with csv
                ($ '#product_sizes').val(map_label_values('size'))
                ($ '#product_colors').val(map_label_values('color'))
                ($ '#product_instagram_tag').val(map_label_values('instagram-tag'))

            .on 'change', '.product-unlimited-quantity', ->
                status = if ($ @).prop('checked') then true else false
                ($ '#product_quantity').prop('disabled', status).val('')

            .on 'click', '.refresh-form', ->
                render_new_product_form({storeSlug: gon.store_slug})


        ($ '.product-widgets')

            # show/hide product image gallery
            .on 'click', '.product-image-wrapper', ->
                # .product-photos-gallery is shown/hidden
                # by css based on .products-gallery-displayed
                product_widget = ($ @).closest('.product-widget')

                # zoom in/out hidden if 0 or 1 in css
                return if +(product_widget.data('rawProductPhotoCount')) is 0
                return if +(product_widget.data('rawProductPhotoCount')) is 1

                if product_widget.hasClass(product_photos_gallery_displayed)
                    product_widget.removeClass(product_photos_gallery_displayed)
                else
                    reset_product_photo_galleries()
                    product_widget.addClass(product_photos_gallery_displayed)

            # update product-widget image
            .on 'click', '.product-photos-gallery-photo', ->
                ($ @).closest('.product-widget').find('.product-photo')
                    .attr('src', ($ @).attr('src'))
