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

update_h2 = (text) -> ($ '#product_form_wrapper').find('h2').text(text)

reset_h2 = -> update_h2('Add Product')

render_edit_product_form = (product) ->
    update_h2("Edit #{product.name}")
    ($ '#product_form_wrapper').find('form')
        .replaceWith(Mustache.render(product_form_template, product))
    ($ window).scrollTop(($ '#product_form_wrapper'))

render_new_product_form = ->
    ($ '#product_form_wrapper').find('form')
        .replaceWith(Mustache.render(product_form_template, {storeSlug: gon.store_slug}))
    reset_h2()
    fetch_user_photos(render_user_photos)

update_product_count = (product_count) -> ($ '#product_count').text(product_count)

render_product_widgets = (product_widgets) ->
    return if product_widgets.length == 0
    $wrapper = $('<div/>')
    for product_widget in product_widgets
        $wrapper.append(Mustache.render(product_widget_template, product_widget))
    ($ '.product-widgets').html($wrapper)
    update_product_count("#{product_widgets.length} Products")

fetch_product_widgets = (callback) ->
    $.ajax
        url: "/stores/#{gon.store_slug}/products"
        dataType: 'json'
        success: (response) -> callback(response) if response

fetch_and_render_product_widgets = (callback = render_product_widgets) ->
    fetch_product_widgets(callback)

render_user_photos = (user_photos) ->
    ($ '#product_form_wrapper').find('.product-photos')
        .replaceWith(Mustache.render(user_photos_template, user_photos))

fetch_user_photos = (callback, product_slug = '') ->
    $.ajax
        url: '/get_instagram_feed_for_current_user'
        data: { product_slug }
        dataType: 'json'
        success: (response) -> callback(response)

if gon.page is 'stores_show'
    $ ->
        render_product_widgets(gon.product_widgets)

        ($ '.product-widgets').on 'click', '.edit-product', ->
            data = ($ @).closest('.product-widget').data()
            data.put = true
            render_edit_product_form(data)
            fetch_user_photos(render_user_photos, data.slug)

        ($ '#product_form_wrapper').on 'submit', 'form', (e) ->
            e.preventDefault()
            verb = if @id is 'new_product' then 'created' else 'updated'
            $.ajax
                url: ($ @).prop('action')
                data: ($ @).serialize()
                type: 'post'
                dataType: 'json'
                success: (response) =>
                    if response.status isnt 'error'
                        clear_alert_and_notice()
                        update_notice("'#{response.name}' has been #{verb} successfully.")
                        update_alert(response.alert) if response.alert?
                        setTimeout ->
                            clear_alert_and_notice()
                        , 10000
                        render_new_product_form()
                        fetch_and_render_product_widgets()
                    else
                        ($ '.form-errors-wrapper').html(Mustache.render(form_error_template, {errors: response.errors}))
                        ($ window).scrollTop(($ '.form-errors-wrapper'))
