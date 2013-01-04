window.templates = {}

GramGoods.render_product_gallery_controls = ->
    if ($ '.product-gallery-control').length > 1
        $('.product-gallery-controls')
            .css('width', $('.product-gallery-controls').width())
            .removeClass('invisible').addClass('display-block')

GramGoods.dirty_commas = (num) ->
    String(num).replace /^\d+(?=\.|$)/, (int) ->
        int.replace /(?=(?:\d{3})+$)(?!^)/g, ','

$ ->
    window.$window = ($ window)
    window.$html = ($ 'html')
    window.$mobile_header = ($ '#mobile_header')
    window.$menu = ($ '#menu')
    window.$menu_button = ($ '#menu_button')
    window.has_touch_events = !$html.hasClass('no-touch')
    window.toggle_menu = -> $menu.toggle()
    window.menu_is_visible = -> $menu.css('display') is 'block'
    window.hide_menu_on_non_child_event = ($el) ->
        toggle_menu() if !$el.closest('.mobile-header').length and menu_is_visible()

    window.forceReflow = (elem = document.documentElement) ->
        #http://stackoverflow.com/a/11478853/382982
        hack = document.createElement("div")
        hack.style.height = "101%"
        document.body.appendChild(hack)
        setTimeout ->
            document.body.removeChild(hack)
            hack = null
        , 0

    if has_touch_events
        # iOS fixed header hacks
        forceReflow()
        ($ 'input, textarea, select')
            .focus(->
                $mobile_header.addClass('absolute')
            ).blur(->
                $mobile_header.removeClass('absolute')
            )
        $window.scroll -> forceReflow()

        # hide/show menu
        $html.tap (e) -> hide_menu_on_non_child_event(($ e.target))
        $window.scroll -> $menu.hide()
        $menu_button.tap((e) ->
            e.preventDefault()
            toggle_menu())

    else
        # hide/show menu
        $html.click (e) -> hide_menu_on_non_child_event(($ e.target))
        $menu_button.click((e) ->
            e.preventDefault()
            toggle_menu())

# ensure logos have been loaded
# before calculating header height
window.addEventListener 'load', ->
    window.header_height =  $mobile_header.height()
    if has_touch_events
        ($ '#mobile_layout_inner').css('padding-top', header_height)

    window.scroll_to_error = ($context) ->
        error_y = $context.find('.unhappy').first().offset().top - header_height - 20
        scrollTo(0, error_y)

Zepto ($) ->

    if gon.page is 'stores_show' or gon.page is 'products_index'
        GramGoods.render_product_views(
            GramGoods.format_products_json(gon.products_json))

    if gon.page is 'stores_show' or gon.page is 'products_index'

        ($ '.products').on('tap', '.product', (e) ->
            e.preventDefault()
            return if ($ @).data('user-owns-store') is 'true'
            destination = ($ @).find('.product-link > a').attr('href')
            location.href = destination
            false
        )

    if gon.page is 'products_show'
        GramGoods.render_product_gallery_controls()

        swipe_left = (e) ->
            $this = ($ e.target)
            next_index = $this.next().data('index')
            if next_index?
                $this.removeClass('on')
                $this.next().addClass('on')
                ($ '.product-gallery-control.on')
                    .removeClass('on').next().addClass('on')

        swipe_right = (e) ->
            $this = ($ e.target)
            previous_index = $this.prev().data('index')
            if previous_index?
                $this.removeClass('on')
                $this.prev().addClass('on')
                ($ '.product-gallery-control.on')
                    .removeClass('on').prev().addClass('on')

        if has_touch_events
            ($ '.product-thumbnail-gallery')
                .on('swipeLeft', (e) -> swipe_left(e))
                .on('swipeRight', (e) -> swipe_right(e))
        else
            ($ '.product-thumbnail-gallery')
                .on('click', '.product-gallery-control', ->
                    index = ($ @).data('index')

                    ($ '.product-gallery-control.on').removeClass('on')
                    ($ @).addClass('on')
                    ($ '.product-thumbnail.on').removeClass('on')
                    ($ "#product_gallery_image_#{index}").addClass('on')
                )


        # setTimeout is required because
        # tap was clicking the purchase
        # link after scrollTo
        ($ '.product-details').tap ->
            setTimeout =>
                scrollTo 0, ($ @).offset().top - (GramGoods.header_offset)
            , 100

        redirect_to_order_form = ->
            data =
                product_id: gon.product_id
                quantity: (+($.trim(($ '#quantity').val()))) or 1
            if ($ '#color').length > 0
                data.color = $.trim(($ '#color').val())
            if ($ '#size').length > 0
                data.size = $.trim(($ '#size').val())
            if gon.layout is 'mobile'
                data.layout = 'mobile'

            window.location = "#{gon.create_order_url}?#{$.param(data)}"

        $redirect_to_order_form = ($ '#redirect_to_order_form')
        if has_touch_events
            $redirect_to_order_form.tap -> redirect_to_order_form()
        else
            $redirect_to_order_form.click -> redirect_to_order_form()

if gon.page is 'stores_new' or gon.page is 'stores_edit' or gon.page is 'stores_proxy' or gon.page is 'stores_create' or gon.page is 'stores_update'
    $ ->
        ($ '.mobile-form')
            .isHappy(store_form_validation_rules)
            .submit((e) ->
                if ($ @).find('.unhappy').length
                    e.preventDefault()
                    scroll_to_error(($ @)))
        ($ '#store_terms_of_service').click -> ($ '.mobile-form').trigger('submit')

if gon.page is 'orders_new' or gon.page is 'orders_edit' or gon.page is 'orders_create'
    $ ->
        $credit_card_number = $('#credit_card_number')
        $credit_card_expiration_month = $('#credit_card_expiration_month')
        $credit_card_expiration_year = $('#credit_card_expiration_year')

        stripeResponseHandler = (status, response) ->
            if response.error
                alert response.error.message
                ($ '#order_form_submit').prop('disabled', '')
            else
                $credit_card_number.val('')
                $credit_card_expiration_month.val('')
                $credit_card_expiration_year.val('')
                token = response['id']
                $(".order-form")
                    .append("<input type='hidden' name='stripeToken' value='#{token}'/>")
                    .get(0)
                        .submit()

        ($ "#order_form")
            .isHappy(order_form_validation_rules)
            .submit (e) ->
                e.preventDefault()

                # this is really hacky, but it's all happy.js gives us to work with
                unless ($ @).find('.unhappy').length
                    ($ '#order_form_submit').prop('disabled', 'disabled')
                    Stripe.createToken({
                        number: $credit_card_number.val(),
                        exp_month: $credit_card_expiration_month.val(),
                        exp_year: $credit_card_expiration_year.val()
                    }, stripeResponseHandler)
                else
                    scroll_to_error(($ @))

render_nested_product_attribute_input = ($el) ->
    attribute = $el.data('attribute')
    fieldset = $el.closest('fieldset')
    input = fieldset.find('input[type=text]')
    value = input.val()
    data =
        n: (new Date().getTime())
        name: attribute
        value: value
    span_template = templates.product_form_nested_attribute_span_template
    hidden_input_template = templates.product_form_nested_resource_input_template

    unless value is ''
        input.val('')
        fieldset.find('.attrs').append(
            Mustache.render(span_template, data, {hidden_input_template}))

    input.trigger('focus')

if gon.page is 'products_new' or gon.page is 'products_create' or gon.page is 'products_edit' or gon.page is 'products_update'
    $ ->
        $mobile_form = ($ '.mobile-form')
        $mobile_form
            .on 'click', '.add-button', (e) ->
                # tap submits the form on iOS
                e.preventDefault()
                render_nested_product_attribute_input ($ @)
            .on 'click', '.attribute-wrapper', (e) ->
                id = ($ @).find('.remove-attribute').data('id')
                attribute = ($ @).find('.remove-attribute').data('attribute')

                if confirm "Are you sure you want to remove #{attribute}?"
                    ($ "##{id}").remove()

        ($ '#product_unlimited_quantity').change ->
            if ($ @).prop('checked')
                val = ($ '#product_quantity').val()
                ($ '#product_quantity')
                    .data('val', val)
                    .prop('disabled', 'disabled')
                    .val('')
            else
                val = ($ '#product_quantity').data('val')
                ($ '#product_quantity')
                    .prop('disabled', '')
                    .val(val)
            $mobile_form.trigger('submit')

        $mobile_form
            .isHappy(product_form_validation_rules)
            .submit (e) ->
                if ($ @).find('.unhappy').length
                    e.preventDefault()
                    scroll_to_error(($ @))

