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

if gon.page is 'stores_show'
    $ ->
        $wrapper = $('<div/>')
        for product_widget in gon.product_widgets
            $wrapper.append(Mustache.render(product_widget_template, product_widget))
        ($ '.product-widgets').append($wrapper)

        ($ '#new_product').submit (e)->
            e.preventDefault()
            $.ajax
                url: '/products'
                data: ($ @).serialize()
                type: 'post'
                dataType: 'json'
                success: (response) ->
                    clear_alert_and_notice()
                    update_notice("'#{response.name}' has been created successfully.")
                    update_alert(response.alert) if response.alert?

                    $.get "/stores/#{gon.store_slug}/products/#{response.slug}", (response)->
                        $('.product-widgets').append(Mustache.render(product_widget_template, response))
