window.templates = {}

if gon.page is 'stores_show' or gon.page is 'products_show' or gon.page is 'products_index' or gon.page is 'stores_new'
    # only reveal product gallery controls if there
    # is more than one product image
    render_product_gallery_controls = ->
        if ($ '.product-gallery-control').length > 1
            $('.product-gallery-controls')
                .css('width', $('.product-gallery-controls').width())
                .removeClass('invisible').addClass('display-block')

    dirty_commas = (num) ->
        String(num).replace /^\d+(?=\.|$)/, (int) ->
            int.replace /(?=(?:\d{3})+$)(?!^)/g, ','

    render_single_product_image = ($self, photos) ->
        product_image = photos[0]
        product_image_template = """
        <img class='product-thumbnail' src='{{product_image}}' alt='' />
        """
        $self.find('.product-left').html(
            Mustache.render product_image_template, { product_image }
        )

    render_multiple_product_images = ($self, product_images) ->
        $product_gallery_wrapper = $('<div />')
        product_thumbnail_gallery_image_template = """
        <img src="{{product_image}}" data-index="{{index}}" class="{{classes}}" alt="{{product_name}}">
        """

        product_thumbnail_gallery_control_template = """
        <a href="javascript: void(0);" data-index="{{index}}" class="{{classes}}"></a>
        """

        $product_gallery_controls_wrapper = $("<div class='product-gallery-controls invisible'></div>")

        for product_image, i in product_images
            product_gallery_data =
                index: i
                classes: "product-thumbnail #{(if i is 0 then 'on' else 'hide')}"
                product_name: gon.product_name
                product_image: product_image

            $product_gallery_wrapper.append Mustache.render(
                product_thumbnail_gallery_image_template, product_gallery_data)

            product_gallery_control_data =
                classes: "product-gallery-control #{(if i is 0 then 'on' else '')}"
                index: i

             $product_gallery_controls_wrapper.append Mustache.render(
                product_thumbnail_gallery_control_template, product_gallery_control_data)

        $self.find('.product-thumbnail-gallery')
            .html($product_gallery_wrapper)
            .append($product_gallery_controls_wrapper)

        render_product_gallery_controls()

    fetch_product_images = ($self, callback) ->
        tag = $self.data('instagram-tag')
        store_slug = $self.data('store-slug')
        $.ajax
            dataType: 'json'
            url: '/get_instagram_feed_for_user_and_filter_by_tag'
            data:
                tag: tag
                store_slug: store_slug
            success: (response) =>
                if response.status is 'error'
                    #alert 'i don\'t know what to do yet'
                else
                    callback($self, response.product_images)

    Zepto ($) ->
        # fixes iOS sticky fixed position bug
        # when navigating from stores/show to
        # products/show the header would stick
        # at the position it was set to at page unload
        header_fix = -> scrollTo(0, 0)

        if gon.page is 'stores_new'
            ($ '#sign_up_and_create_store').click ->
                form_data = ($ '#new_store').serialize()
                auth_url = gon.auth_url
                window.location = "#{auth_url}?#{form_data}"

        if gon.page is 'stores_show'
            $('.product').each ->
                fetch_product_images(($ @), render_single_product_image)

        if gon.page is 'stores_show' or gon.page is 'products_index'
            header_fix()

            $('.product').each ->
                fetch_product_images(($ @), render_single_product_image)


            ($ '.products').on('tap', '.product', ->
                destination = ($ @).find('.product-link > a').attr('href')
                location.href = destination)

        if gon.page is 'products_show'
            header_fix()

            fetch_product_images($('.product'), render_multiple_product_images)



            ($ '.product-thumbnail').swipeLeft ->
                next_index = ($ @).next().data('index')
                if next_index?
                    ($ @).addClass('hide')
                    ($ @).next().removeClass('hide')
                    ($ '.product-gallery-control.on')
                        .removeClass('on').next().addClass('on')

            ($ '.product-thumbnail').swipeRight ->
                previous_index = ($ @).prev().data('index')
                if previous_index?
                    ($ @).addClass('hide')
                    ($ @).prev().removeClass('hide')
                    ($ '.product-gallery-control.on')
                        .removeClass('on').prev().addClass('on')

            # setTimeout is required because
            # tap was clicking the purchase
            # link after scrollTo
            ($ '.product-details').tap ->
                setTimeout =>
                    scrollTo 0, ($ @).offset().top - 56
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

            ($ '#redirect_to_order_form').tap -> redirect_to_order_form()

            # for desktop users
            ($ '#redirect_to_order_form').click (e) -> redirect_to_order_form()

if gon.page is 'orders_new' or gon.page is 'orders_edit' or gon.page is 'orders_create'
    $credit_card_number = $('#credit_card_number')
    $credit_card_expiration_month = $('#credit_card_expiration_month')
    $credit_card_expiration_year = $('#credit_card_expiration_year')

    stripeResponseHandler = (status, response) ->
        if response.error
            alert response.error.message
            ($ '#order_form_submit').attr('disabled', false)
        else
            $credit_card_number.val('')
            $credit_card_expiration_month.val('')
            $credit_card_expiration_year.val('')
            token = response['id']
            $(".order-form")
                .append("<input type='hidden' name='stripeToken' value='#{token}'/>")
                .get(0)
                    .submit()

    $ ->
        ($ "#order_form")
            .isHappy(order_form_validation_rules)
            .submit((e) ->
                e.preventDefault()

                # this is really hacky, but it's all happy.js gives us to work with
                unless ($ @).find('.unhappy').length
                    ($ '#order_form_submit').attr('disabled', true)
                    Stripe.createToken({
                        number: $credit_card_number.val(),
                        exp_month: $credit_card_expiration_month.val(),
                        exp_year: $credit_card_expiration_year.val()
                    }, stripeResponseHandler))

