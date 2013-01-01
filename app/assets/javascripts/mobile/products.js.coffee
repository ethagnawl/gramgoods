if gon.page is 'products_new' or gon.page is 'products_create' or gon.page is 'products_edit' or gon.page is 'products_update'
    $ ->
        max_id = 'nil'
        photo_template = templates.existing_photo_grid_photo_template

        ($ '#existing_photo_grid').on 'click', '.photo-wrapper', ->
            ($ @).toggleClass('selected')

        fetch_and_render_existing_photos = ->
            $.ajax
                url: '/fetch_instagram_feed_for_user'
                data: { max_id }
                error: -> alert GramGoods.error_message
                success: (_response) ->
                    response = JSON.parse(_response)

                    unless response.status is 'success'
                        message = if response.alert?
                            response.alert
                        else
                            GramGoods.error_message

                        alert message
                    else
                        $wrapper = $('<div />')
                        max_id = response.max_id

                        for product_image in response.product_images
                            img = Mustache.render photo_template, { product_image }
                            $wrapper.append(img)

                        $('#existing_photo_grid').append($wrapper)
                        $('#existing_photo_grid_wrapper').removeClass('hide')
                        $('#default_submit_buttons').addClass('hide')

        ($ '#add_existing_photos, #fetch_additional_existing_photos')
            .on 'tap click', ->
                fetch_and_render_existing_photos()


        ($ 'form').submit ->
            alert $('.photo-wrapper.selected').length
