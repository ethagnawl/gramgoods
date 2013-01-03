if gon.page is 'products_new' or gon.page is 'products_create' or gon.page is 'products_edit' or gon.page is 'products_update'
    $ ->
        max_id = 'nil'
        user_media_count = 0
        photo_grid_media_count = 0
        set_user_media_count = _.once (media_count) -> user_media_count = media_count

        photo_template = templates.existing_photo_grid_photo_template

        $existing_photo_grid = ($ '#existing_photo_grid')
        $loading_buttons = [($ '#add_existing_photos'),
                            $('#fetch_additional_existing_photos')]

        $product_images = ($ '#product_images')

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

        update_product_image_array = ($product_image) ->
            photo_url = $product_image.data('url')
            product_images = _.compact($product_images.val().split(','))

            if $product_image.hasClass('selected')
                product_images.push(photo_url)
            else
                product_images = _.without(product_images, photo_url)

            $product_images.val product_images.join(',')

        toggle_photo_wrapper_state = ($el) -> $el.toggleClass('selected')

        photo_wrapper_click_handler = ($el) ->
            toggle_photo_wrapper_state $el
            update_product_image_array $el

        if has_touch_events
            $existing_photo_grid.on 'tap', '.photo-wrapper', ->
                photo_wrapper_click_handler ($ @)
        else
            $existing_photo_grid.on 'click', '.photo-wrapper', ->
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
                        $wrapper = $('<div />')
                        max_id = response.max_id
                        set_user_media_count(+(response.media_count))
                        photo_grid_media_count += response.product_images.length

                        if user_media_count is photo_grid_media_count
                            disable_all_loading_buttons()

                        for product_image in response.product_images
                            img = Mustache.render photo_template, { product_image }
                            $wrapper.append(img)

                        $existing_photo_grid.append($wrapper)
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
