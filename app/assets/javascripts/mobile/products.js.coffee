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

        toggle_photo_wrapper_state = ($el) ->
            $el.toggleClass('selected')

        if has_touch_events
            $existing_photo_grid.on 'tap', '.photo-wrapper', ->
                toggle_photo_wrapper_state ($ @)
        else
            $existing_photo_grid.on 'click', '.photo-wrapper', ->
                toggle_photo_wrapper_state ($ @)

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
