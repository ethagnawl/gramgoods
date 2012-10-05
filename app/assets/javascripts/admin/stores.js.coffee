
if gon.page is 'stores_new' or gon.page is 'stores_edit'
    $ -> ($ '#store_form_wrapper').find('form').validate store_form_options

if gon.page is 'stores_show'

    #config
    multiple_value_inputs = [
        # each input has a 'product_' prefix and a 's' suffix
        # i.e. 'product_instagram_tags'
        'color'
        'size'
    ]

    dummy_share_text = 'Ex. Buy Blue Jeans for $50.00 right now by visiting @YourInstagramAccount or clicking this link: http://gramgoods.com/your-new-store/your-new-product'

    product_photos_gallery_displayed = 'product-photos-gallery-displayed'

    product_form_submission_error_callback = (self, response) ->
        if response.errors?
            errors = response.errors
        else if response.status is 500 and response.statusText?
            errors = [{error: "#{response.statusText} - Please review your information and try submitting the form again."}]
        else
            errors = null

        ($ self).removeClass(hide)

        ($ '.form-errors-wrapper').html(
            if errors?
                Mustache.render(
                    templates.form_error_template, {
                        errors: errors }))
        $window.scrollTop(($ '.form-errors-wrapper'))

    reset_product_form = (data) ->
        $product_form_wrapper.find('form').replaceWith($('<form />'))
        $window.scrollTop($product_form_wrapper)
        update_h2(Mustache.render(templates.stores_h2_add_template, {}))

    update_product_form = (data) ->
        product_form_label_template = templates.product_form_label_template
        $product_form_wrapper.find('form')
            .replaceWith(
                Mustache.render(
                    templates.product_form_template, data, {
                        product_form_label_template }))
        $product_form_wrapper.find('form').validate(product_form_options)
        $window.scrollTop($product_form_wrapper)

    render_edit_product_form = (data) ->
        $.getJSON("/#{data.store_slug}/#{data.product_slug}", (response) ->
            update_product_form(response)
            update_h2(
                Mustache.render(
                    templates.stores_h2_edit_template, { name: response.name }))
            render_user_photos { product_photos: response.product_photos }
            fetch_user_photos(
                render_user_photo_feed, { product_slug: response.slug }))

    render_new_product_form = (data) ->
        data.dummy_share_text = dummy_share_text
        update_product_form(data)
        reset_h2()
        unless gon.authenticated is false
            fetch_user_photos(render_user_photo_feed, { product_slug: data.slug })

    render_nested_attribute_template = (name, $context) ->
        container = $('<div />').attr('class', 'hide')
        ($ ".label-#{name}").each (i, label) ->
            data =
                n: i
                name: name
                value: ($ label).data('value')
            container.append(
                Mustache.render(
                    templates.product_form_nested_resource_input_template, data))
        $context.append(container)

    trigger_process_csv = ($input) ->
        if $input.val()?
            $input
                .parent()
                    .find('.add-product-form-label').trigger('click')

    # hide open product-widget photo galleries
    reset_product_photo_galleries = ->
        ($ ".#{product_photos_gallery_displayed}").each ->
            ($ @).removeClass(product_photos_gallery_displayed)

    # select product photo for inclusion
    select_photo = ($el) ->
        $el.toggleClass('selected')
        $el.find('.btn').toggleClass('btn-success btn-inverse')

    update_alert = (message) ->
        ($ '.rails-alert').removeClass(hide) if ($ '.rails-alert').hasClass(hide)
        ($ '.rails-alert').text(message)
        $window.scrollTop(0)

    update_notice = (message) ->
        ($ '.rails-notice').removeClass(hide) if ($ '.rails-notice').hasClass(hide)
        ($ '.rails-notice').text(message)
        $window.scrollTop(0)

    expire_alert_and_notice_in = (seconds) ->
        if clear_alert_and_notice_timeout?
            clearTimeout(clear_alert_and_notice_timeout)
        clear_alert_and_notice()
        window.clear_alert_and_notice_timeout = setTimeout ->
            clear_alert_and_notice()
        , seconds

    clear_alert_and_notice = ->
        ($ '.rails-notice, .rails-alert').text('').addClass(hide)

    update_h2 = (text) -> $product_form_wrapper.find('h2').first().html(text)

    reset_h2 = -> update_h2(Mustache.render(templates.stores_h2_add_template, {}))

    update_product_count = (product_count) ->
        ($ '#product_count').text("#{product_count} Products")

    render_product_widgets = (product_widgets) ->
        if product_widgets.length is 0
            ($ '.product-widgets').empty()
        else
            $wrapper = $('<div/>')
            for product_widget in product_widgets
                _product_widget = JSON.parse(product_widget)
                _product_widget._product_photos = JSON.stringify _product_widget.product_photos
                $wrapper.append(Mustache.render(templates.product_widget_template, _product_widget))
            ($ '.product-widgets').html($wrapper)
        update_product_count(product_widgets.length)

    fetch_product_widgets = (callback) ->
        $.ajax
            url: "/stores/#{gon.store_slug}/products"
            success: (response) -> callback(response) if response

    fetch_and_render_product_widgets = (callback = render_product_widgets) ->
        fetch_product_widgets(callback)

    window.update_user_photos = (user_photos) ->
        container = $('<div />')
        for user_photo in user_photos.product_photos
            container.append(
                Mustache.render(
                    templates.product_photo_template, user_photo))
        $product_form_wrapper.find('.product-photo:last').after(container)
        ($ '.fetch-more-user-photos').data('maxId', user_photos.max_id)

    window.render_user_photos = (user_photos) ->
        $product_form_wrapper.find('.product-photos')
            .replaceWith(
                Mustache.render(
                    templates.product_photos_template, user_photos, {
                        product_photo: templates.product_photo_template }))

    window.render_user_photo_feed = (user_photos) ->
        $product_form_wrapper.find('.photo-feed')
            .replaceWith(
                Mustache.render(
                    templates.user_photo_feed_template, user_photos, {
                        product_photo: templates.product_photo_template }))

    window.fetch_user_photos = (callback = render_user_photos, options = {}) ->
        $.ajax
            url: '/get_instagram_feed_for_current_user'
            data: options
            success: (response) ->
                if response.status isnt 'error'
                    callback(response)
                else
                    update_alert(response.alert)

    destroy_product = (store_id, id, callback) ->
        $.ajax
            url: "/products/#{product_slug}"
            data: { store_id, id }
            type: 'delete'
            success: (response) ->
                if response.status is 'success'
                    callback()
                    update_notice(response.notice) if response.notice?
                    reset_product_form()
    $ ->
        render_product_widgets(gon.product_widgets)

        ($ '.product-widgets')
            # show/hide product image gallery
            .on 'click', '.product-photo-wrapper', ->
                # .product-photos-gallery is shown/hidden
                # by css based on .products-gallery-displayed
                product_widget = ($ @).closest('.product-widget')

                if product_widget.hasClass(product_photos_gallery_displayed)
                    product_widget.removeClass(product_photos_gallery_displayed)
                else
                    reset_product_photo_galleries()
                    product_widget.addClass(product_photos_gallery_displayed)

            # update product-widget image
            .on 'click', '.product-photos-gallery-photo', ->
                ($ @).closest('.product-widget').find('.product-photo')
                    .attr('src', ($ @).attr('src'))

            .on 'click', '.edit-product', ->
                data = ($ @).closest('.product-widget').data()
                data.put = true
                render_edit_product_form(data)

            .on 'click', '.delete-product', ->
                data = ($ @).closest('.product-widget').data()
                if confirm("Are you sure you want to delete #{data.name}?")
                    destroy_product(
                        gon.store_slug, data.product_slug, fetch_and_render_product_widgets)

            .on 'click', '.copy-to-clipboard', ->
                key = if navigator.platform.indexOf('Mac') isnt -1
                        'Command'
                      else
                        'Control'
                base = window.location.href.split(window.location.pathname)[0]
                url = ($ @).data('url')

                prompt("""
                    Copy to Clipboard
                    #{key} + C, Enter
                """, "#{base}/#{url}")

        append_to_control_group = ($control_group, hash) ->
            $control_group.append(Mustache.render(
                templates.product_form_label_template, hash))

        csv_to_product_form_labels = ($input, name) ->
            _values = $input.val()
            return unless _values
            $input.val('')
            for value in _values.split(',')
                value = $.trim(value)
                return unless value.length
                append_to_control_group(
                    $input.closest('.control-group'), { name, value })

        $product_form_wrapper
            .on 'click', '.add-instagram-tag', ->
                _instagram_tags = ($ '#product_instagram_tags').val()
                ($ '#product_instagram_tags').val('')
                tagged_photo_count = 0

                if _instagram_tags
                    for instagram_tag in _instagram_tags.split(',')
                        instagram_tag = $.trim(instagram_tag)
                        return unless instagram_tag.length
                        if instagram_tag.indexOf('#') isnt -1
                            instagram_tag = instagram_tag.split('#')[1]

                        append_to_control_group(($ @).closest('.control-group'), {
                            value: "##{instagram_tag}",
                            name: 'instagram_tag'})

                        photos_with_tags = $product_form_wrapper
                            .find(".photo-feed div[data-tags~='#{instagram_tag}']")
                            .not('.selected')

                        if photos_with_tags.length > 0
                            photos_with_tags.each -> select_photo(($ @))
                            tagged_photo_count += photos_with_tags.length

                    if tagged_photo_count > 0
                        pluralized_photo = if tagged_photo_count is 1 then 'photo' else 'photos'
                        pluralized_has =  if tagged_photo_count is 1 then 'has' else 'have'
                        expire_alert_and_notice_in(6000)
                        update_notice("""
                            #{tagged_photo_count} #{pluralized_photo} from your feed
                            ##{pluralized_has} been linked.
                        """)

            .on 'click', '.add-size', ->
                csv_to_product_form_labels(($ '#product_sizes'), 'size')

            .on 'click', '.add-color', ->
                csv_to_product_form_labels(($ '#product_colors'), 'color')

            .on 'click', '.remove-label', ->
                ($ @).parent().remove()

            .on 'click', '.render-new-product-form', ->
                render_new_product_form({store_slug: gon.store_slug})
                update_h2(Mustache.render(templates.stores_h2_remove_template, {}))

            .on 'click', '.hide-new-product-form, .hide-product-form', ->
                if confirm("""
                    Are you sure you want to close this form?
                    \n
                    Any changes will be lost.
                """)
                    reset_product_form()

            .on 'change', '.product-unlimited-quantity', ->
                status = if ($ @).prop('checked') then true else false
                ($ '#product_quantity').prop('disabled', status).val('')

            .on 'click', '.product-photo', ->
                select_photo(($ @))

            .on 'click', '.fetch-more-user-photos', ->
                fetch_user_photos(update_user_photos, {max_id: ($ @).data('maxId')})

            .on 'submit', 'form', (e) ->
                e.preventDefault()

                # hide form to conceal input manipulation
                ($ @).addClass(hide)

                # process values left in instagram tag, color and size inputs
                # i.e. user entered #hat, #shirt but didn't click the add buton
                for input in multiple_value_inputs
                    trigger_process_csv(($ "#product_#{input}s"))

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
                            likes: data.likes
                            thumbnail: data.thumbnail
                            instagram_id: data.instagramId
                            product_image_n: i))
                ($ @).append(container)

                # build nested attribute inputs for instagram_tag, color and size
                for input in multiple_value_inputs
                    render_nested_attribute_template(input, ($ @))

                verb = if @id is 'new_product' then 'created' else 'updated'

                $.ajax
                    url: ($ @).prop('action')
                    type: 'post'
                    data: ($ @).serialize()
                    error: (response) =>
                        product_form_submission_error_callback(@, response)
                    success: (response) =>
                        if response.status isnt 'error'
                            expire_alert_and_notice_in(6000)
                            update_notice("'#{response.product.name}' has been #{verb} successfully.")
                            update_alert(response.alert) if response.alert?
                            reset_product_form()
                            fetch_and_render_product_widgets()
                        else
                            product_form_submission_error_callback(@, response)
