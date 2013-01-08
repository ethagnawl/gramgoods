$view_more_products = ($ document.getElementById('view_more_products'))

disable_$view_more_products = (permanent = false) ->
    $view_more_products
        .attr('disabled', 'disabled')
        .text('Loading Products...')
    $view_more_products.addClass('hide') if permanent

enable_$view_more_products = ->
    $view_more_products
        .removeAttr('disabled')
        .text('View More Products')

increment_pagination_page = -> gon.pagination_page = +(gon.pagination_page) + 1

GramGoods.format_products_json = (_products) -> JSON.parse(_products).products

window.fetch_products = (params) ->
    $.ajax
        dataType: 'json'
        url: params.url
        success: (response, status, xhr) =>
            params['success_callback'](response)
        error: (xhr, errorType, error) =>
            params['error_callback'](error)

unique_id = -> "div_#{(new Date).getMilliseconds()}"

y_offset = (id) ->
    $(document.getElementById(id)).offset().top - (GramGoods.header_offset * 2)

GramGoods.render_product_views = (products) ->
    _unique_id = unique_id()

    $wrapper = $('<div>').attr({
        id: _unique_id,
        class: 'product-page'
    })

    for product in products
        $wrapper.append(Mustache.render(templates.product_template, product))

    $('.products').append($wrapper)
    scrollTo 0, y_offset(_unique_id)

fetch_more_products = ->
    increment_pagination_page()

    url_root = if gon.page is 'products_index' then '/products' else "/#{gon.store_slug}/"
    url = "#{url_root}?page=#{gon.pagination_page}"

    params =
        url: url
        page: gon.pagination_page
        success_callback: (response) ->
            products = GramGoods.format_products_json(response.products_json)

            if products.length > 0
                unless gon.pagination_page is gon.max_pagination_page
                    enable_$view_more_products()
                else
                    disable_$view_more_products(true)
                GramGoods.render_product_views(products)

        error_callback: (error) -> alert(error) if gon.debug

    fetch_products(params)

$view_more_products.click ->
    unless ($ @).attr('disabled')
        disable_$view_more_products()
        fetch_more_products()
