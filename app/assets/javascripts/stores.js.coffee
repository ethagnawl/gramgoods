window.reset_product_form = (data) ->
    ($ '#product_form_wrapper').find('form')
        .replaceWith($('<form />'))
    ($ window).scrollTop(($ '#product_form_wrapper'))
    update_h2("Add Product <a class='render-new-product-form' href='javascript: void(0);'>+</a>")

window.update_product_form = (data) ->
    ($ '#product_form_wrapper').find('form')
        .replaceWith(Mustache.render(product_form_template, data))
    ($ window).scrollTop(($ '#product_form_wrapper'))

window.render_edit_product_form = (data) ->
    update_product_form(data)
    update_h2("Edit #{data.name}")
    fetch_user_photos(render_user_photos, data.slug)

window.render_new_product_form = (data) ->
    update_product_form(data)
    reset_h2()
    fetch_user_photos(render_user_photos)

if gon.page is 'stores_show'
    update_alert = (message) ->
        ($ '.rails-alert').removeClass('hide') if ($ '.rails-alert').hasClass('hide')
        ($ '.rails-alert').text(message)
        ($ window).scrollTop(0)

    update_notice = (message) ->
        ($ '.rails-notice').removeClass('hide') if ($ '.rails-notice').hasClass('hide')
        ($ '.rails-notice').text(message)
        ($ window).scrollTop(0)

    clear_alert_and_notice = ->
        ($ '.rails-notice, .rails-alert').text('').addClass('hide')

    update_h2 = (text) -> ($ '#product_form_wrapper').find('h2').first().html(text)

    reset_h2 = -> update_h2('Add Product')


    update_product_count = (product_count) ->
        ($ '#product_count').text("#{product_count} Products")

    render_product_widgets = (product_widgets) ->
        if product_widgets.length == 0
            ($ '.product-widgets').empty()
        else
            $wrapper = $('<div/>')
            for product_widget in product_widgets
                $wrapper.append(Mustache.render(product_widget_template, product_widget))
            ($ '.product-widgets').html($wrapper)
        update_product_count(product_widgets.length)

    fetch_product_widgets = (callback) ->
        $.ajax
            url: "/stores/#{gon.store_slug}/products"
            success: (response) -> callback(response) if response

    fetch_and_render_product_widgets = (callback = render_product_widgets) ->
        fetch_product_widgets(callback)

    render_user_photos = (user_photos) ->
        ($ '#product_form_wrapper').find('.product-photos')
            .replaceWith(Mustache.render(user_photos_template, user_photos))

    fetch_user_photos = (callback, product_slug = '') ->
        $.ajax
            url: '/get_instagram_feed_for_current_user'
            data: { product_slug } unless product_slug is ''
            success: (response) -> callback(response)

    destroy_product = (store_slug, product_slug, callback) ->
        $.ajax
            url: "/products/#{product_slug}"
            data:
                store_slug: store_slug
                product_slug: product_slug
            type: 'delete'
            success: (response) ->
                if response.status is 'success'
                    callback()
                    update_notice(response.notice) if response.notice?

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

        ($ '#product_form_wrapper')
            .on 'click', '.render-new-product-form', ->
                render_new_product_form({storeSlug: gon.store_slug})
                update_h2('Add Product <a class="hide-new-product-form" href="javascript:void(0);">-</a>')
            .on 'click', '.hide-new-product-form', ->
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
                            clear_alert_and_notice()
                            update_notice("'#{response.product.name}' has been #{verb} successfully.")
                            update_alert(response.alert) if response.alert?
                            setTimeout ->
                                clear_alert_and_notice()
                            , 10000
                            reset_product_form()
                            fetch_and_render_product_widgets()
                        else
                            ($ '.form-errors-wrapper').html(Mustache.render(form_error_template, {errors: response.errors}))
                            ($ window).scrollTop(($ '.form-errors-wrapper'))
