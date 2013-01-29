if gon.page is 'products_new' or gon.page is 'products_create' or gon.page is 'products_edit' or gon.page is 'products_update'
    $ ->
        loading_photos = true
        max_id = 'nil'
        user_media_count = 0
        photo_grid_media_count = 0
        set_user_media_count = _.once (media_count) -> user_media_count = media_count

        existing_photo_grid_photos_template = templates.existing_photo_grid_photos_template
        existing_photo_grid_photo_template = templates.existing_photo_grid_photo_template

        $existing_photo_grid_wrapper = ($ '#existing_photo_grid_wrapper')
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
            product_image_urls = ($ '.photo-wrapper.selected').map ->
                ($ @).data('url')
            $product_images.val product_image_urls

        toggle_photo_wrapper_state = ($el) -> $el.toggleClass('selected')

        photo_wrapper_click_handler = ($el) ->
            toggle_photo_wrapper_state $el
            update_product_image_array $el

        $product_images_wrapper.each ->
            if has_touch_events
                ($ @).on 'tap', '.photo-wrapper', ->
                    photo_wrapper_click_handler ($ @)
            else
                ($ @).on 'click', '.photo-wrapper', ->
                    photo_wrapper_click_handler ($ @)

        fetch_and_render_existing_photos = (pageload = false) ->
            $.ajax
                url: '/fetch_instagram_feed_for_user'
                data: { max_id }
                beforeSend: ->
                    unless pageload
                        if loading_photos
                            return false
                        else
                            loading_photos = true

                complete: ->
                    toggle_all_loading_buttons() unless pageload is true
                    loading_photos = false
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

                        if $existing_photo_grid_wrapper.hasClass('hide')
                            $existing_photo_grid_wrapper.removeClass('hide')

                        if pageload
                            ($ '#loading_product_images_message')
                                .addClass('hide')
                            ($ '#product_form_submit_button_wrapper')
                                .removeClass('hide')

        loading_button_click_handler = ($el) ->
            unless loading_photos
                toggle_all_loading_buttons()
                fetch_and_render_existing_photos()

        ($ '#fetch_additional_existing_photos').each ->
            if has_touch_events
                ($ @).on 'tap', -> loading_button_click_handler ($ @)
            else
                ($ @).on 'click', -> loading_button_click_handler ($ @)

        fetch_and_render_existing_photos(true)

        $('#add_additional_user_product_image').click ->
            console.log new_user_image = Mustache.render(
                templates.product_form_new_user_product_image_template,
                {n: new Date().getMilliseconds()}
            )

            $(this).before(new_user_image)

        ($ '#new_user_product_images').on 'click', '.remove-user-product-image', ->
            ($ @).closest('.widget').remove()

        ($ '#existing_photo_grid_wrapper').on 'click', '.photo-wrapper', ->
            $checkbox = ($ @).find('input.hide')
            bool = !$checkbox.prop('checked')
            $checkbox.prop('checked', bool)
            console.log $checkbox.prop('checked')
