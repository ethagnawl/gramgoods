if gon.page is 'products_new' or gon.page is 'products_create' or gon.page is 'products_edit' or gon.page is 'products_update'
    $ ->
        max_id = 'nil'
        user_media_count = 0
        photo_grid_media_count = 0
        set_user_media_count = _.once (media_count) -> user_media_count = media_count

        existing_photo_grid_photos_template = templates.existing_photo_grid_photos_template
        existing_photo_grid_photo_template = templates.existing_photo_grid_photo_template

        $existing_photo_grid = ($ '#existing_photo_grid')
        $loading_buttons = [($ '#add_existing_photos'),
                            $('#fetch_additional_existing_photos')]

        $product_images = ($ '#product_images')
        $product_images_wrapper = ($ '#product_images_wrapper')

        toggle_loading_message = ($el) ->
            if $el.hasClass('loading')
                $el
                    .text($el.data('original-text'))
                    .removeClass('loading')
            else
                $el
                    .data('original-text', $el.text())
                    .addClass('loading')
                    .text 'Loading...'

        toggle_all_loading_buttons = ->
            toggle_loading_message($el) for $el in $loading_buttons

        disable_all_loading_buttons = ->
            $el.addClass('hide') for $el in $loading_buttons

        update_product_image_array = ->
            console.log product_image_urls = ($ '.photo-wrapper.selected').map ->
                ($ @).data('url')
            $product_images.val product_image_urls

        toggle_photo_wrapper_state = ($el) -> $el.toggleClass('selected')

        photo_wrapper_click_handler = ($el) ->
            toggle_photo_wrapper_state $el
            update_product_image_array $el

        if has_touch_events
            $product_images_wrapper.on 'tap', '.photo-wrapper', ->
                photo_wrapper_click_handler ($ @)
        else
            $product_images_wrapper.on 'click', '.photo-wrapper', ->
                photo_wrapper_click_handler ($ @)

        fetch_and_render_existing_photos = ->
            $.ajax
                url: '/fetch_instagram_feed_for_user'
                data: { max_id }
                complete: -> toggle_all_loading_buttons()
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
                        max_id = response.max_id
                        set_user_media_count(+(response.media_count))
                        photo_grid_media_count += response.product_images.length

                        if user_media_count is photo_grid_media_count
                            disable_all_loading_buttons()

                        product_images = if gon.product_images?
                            _.difference(response.product_images, gon.product_images)
                        else
                            response.product_images

                        product_images = _.map(product_images, (product_image) -> { product_image })

                        $existing_photo_grid.append(
                            Mustache.render(existing_photo_grid_photos_template, {
                                product_images
                            }, {
                                existing_photo_grid_photo_template
                            })
                        )

                        $('#existing_photo_grid_wrapper').removeClass('hide')
                        $('#default_submit_buttons').addClass('hide')

        loading_button_click_handler = ($el) ->
            return false if $el.hasClass('loading')
            toggle_all_loading_buttons()
            fetch_and_render_existing_photos()

        if has_touch_events
            ($ '#add_existing_photos, #fetch_additional_existing_photos')
                .on 'tap', -> loading_button_click_handler ($ @)
        else
            ($ '#add_existing_photos, #fetch_additional_existing_photos')
                .on 'click', -> loading_button_click_handler ($ @)
