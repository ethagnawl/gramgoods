window.reset_product_form = (data) ->
    $product_form_wrapper.find('form')
        .replaceWith($('<form />'))
    $window.scrollTop($product_form_wrapper)
    update_h2(Mustache.render(templates.stores_h2_add_template, {}))

window.update_product_form = (data) ->
    $product_form_wrapper.find('form')
        .replaceWith(Mustache.render(templates.product_form_template, data, {product_form_label_template: templates.product_form_label_template}))
    $product_form_wrapper.find('form').validate(product_form_options)
    $window.scrollTop($product_form_wrapper)

window.render_edit_product_form = (data) ->
    if data.rawInstagramTags
        data.instagram_tags = $.map(data.rawInstagramTags.split(', '), (instagram_tag) ->
            {value: instagram_tag, name: 'instagram-tag'})
    if data.sizes
        data.sizes = $.map(data.sizes.split(','), (size) ->
            {value: size, name: 'size'})
    if data.colors
        data.colors = $.map(data.colors.split(','), (color) ->
            {value: color, name: 'color'})
    update_product_form(data)
    update_h2(Mustache.render(templates.stores_h2_edit_template, {name: data.name}))
    render_user_photos {product_photos: data.productPhotos}
    fetch_user_photos(render_user_photo_feed, {product_slug: data.slug})

window.render_new_product_form = (data) ->
    update_product_form(data)
    reset_h2()
    unless gon.authenticated is false
        fetch_user_photos(render_user_photo_feed, {product_slug: data.slug})

if gon.page is 'stores_new' or gon.page is 'stores_edit'
    $ -> ($ '#store_form_wrapper').find('form').validate store_form_options

if gon.page is 'stores_show'
    update_alert = (message) ->
        ($ '.rails-alert').removeClass(hide) if ($ '.rails-alert').hasClass(hide)
        ($ '.rails-alert').text(message)
        $window.scrollTop(0)

    update_notice = (message) ->
        ($ '.rails-notice').removeClass(hide) if ($ '.rails-notice').hasClass(hide)
        ($ '.rails-notice').text(message)
        $window.scrollTop(0)

    expire_alert_and_notice_in = (seconds) ->
        clearTimeout(clear_alert_and_notice_timeout) if clear_alert_and_notice_timeout?
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
                _product_widget.raw_instagram_tags = ($.map _product_widget.raw_instagram_tags.split(','), (instagram_tag) -> "#{instagram_tag}").join(', ')
                _product_widget.instagram_tags = ($.map _product_widget.raw_instagram_tags.split(','), (instagram_tag) -> {instagram_tag: instagram_tag})
                _product_widget.sizes = _product_widget.sizes.split(',').join(', ')
                _product_widget.colors = _product_widget.colors.split(',').join(', ')
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
            container.append(Mustache.render(templates.product_photo_template, user_photo))
        $product_form_wrapper.find('.product-photo:last').after(container)
        ($ '.fetch-more-user-photos').data('maxId', user_photos.max_id)

    window.render_user_photos = (user_photos) ->
        $product_form_wrapper.find('.product-photos')
            .replaceWith(Mustache.render(templates.product_photos_template, user_photos, product_photo: templates.product_photo_template))

    window.render_user_photo_feed = (user_photos) ->
        $product_form_wrapper.find('.photo-feed')
            .replaceWith(Mustache.render(templates.user_photo_feed_template, user_photos, product_photo: templates.product_photo_template))

    window.fetch_user_photos = (callback = render_user_photos, options = {}) ->
        $.ajax
            url: '/get_instagram_feed_for_current_user'
            data: options
            success: (response) ->
                if response.status isnt 'error'
                    callback(response)
                else
                    update_alert(response.alert)

    destroy_product = (store_slug, product_slug, callback) ->
        $.ajax
            url: "/products/#{product_slug}"
            data: {store_slug, product_slug}
            type: 'delete'
            success: (response) ->
                if response.status is 'success'
                    callback()
                    update_notice(response.notice) if response.notice?
                    reset_product_form()
    $ ->
        render_product_widgets(gon.product_widgets)

        ($ '.product-widgets')
            .on 'click', '.edit-product', ->
                data = ($ @).closest('.product-widget').data()
                data.put = true
                render_edit_product_form(data)
            .on 'click', '.delete-product', ->
                data = ($ @).closest('.product-widget').data()
                if confirm("Are you sure you want to delete #{data.name}?")
                    destroy_product(data.storeSlug, data.slug, fetch_and_render_product_widgets)

        $product_form_wrapper
            .on 'click', '.add-instagram-tag', ->
                instagram_tag = ($ '#product_instagram_tag').val()
                if instagram_tag
                    instagram_tag = instagram_tag.split('#')[1] if instagram_tag.indexOf('#') isnt -1
                    ($ '#product_instagram_tag').val('')
                    ($ @).closest('.control-group').append(Mustache.render(templates.product_form_label_template, {value: "##{instagram_tag}", name: 'instagram-tag'}))
                    photos_with_tags = $product_form_wrapper.find(".photo-feed div[data-tags~='#{instagram_tag}']")
                    if photos_with_tags.length > 0
                        photos_with_tags.each -> select_photo(($ @))
                        pluralized_photo = if photos_with_tags.length is 1 then 'photo' else 'photos'
                        pluralized_has =  if photos_with_tags.length is 1 then 'has' else 'have'
                        expire_alert_and_notice_in(6000)
                        update_notice("#{photos_with_tags.length} #{pluralized_photo} from your feed #{pluralized_has} been linked.")

            .on 'click', '.add-size', ->
                size = ($ '#product_sizes').val()
                if size
                    ($ '#product_sizes').val('')
                    ($ @).closest('.control-group').append(Mustache.render(templates.product_form_label_template, {value: size, name: 'size'}))

            .on 'click', '.add-color', ->
                size = ($ '#product_colors').val()
                if size
                    ($ '#product_colors').val('')
                    ($ @).closest('.control-group').append(Mustache.render(templates.product_form_label_template, {value: size, name: 'color'}))

            .on 'click', '.remove-label', ->
                ($ @).parent().remove()

            .on 'click', '.render-new-product-form', ->
                render_new_product_form({storeSlug: gon.store_slug})
                update_h2(Mustache.render(templates.stores_h2_remove_template, {}))

            .on 'click', '.hide-product-form', ->
                reset_product_form()

            .on 'submit', 'form', (e) ->
                e.preventDefault()

                verb = if @id is 'new_product' then 'created' else 'updated'
                $.ajax
                    url: ($ @).prop('action')
                    data: ($ @).serialize()
                    type: 'post'
                    success: (response) =>
                        if response.status isnt 'error'
                            expire_alert_and_notice_in(6000)
                            update_notice("'#{response.product.name}' has been #{verb} successfully.")
                            update_alert(response.alert) if response.alert?
                            reset_product_form()
                            fetch_and_render_product_widgets()
                        else
                            ($ '.form-errors-wrapper').html(Mustache.render(templates.form_error_template, {errors: response.errors}))
                            $window.scrollTop(($ '.form-errors-wrapper'))
