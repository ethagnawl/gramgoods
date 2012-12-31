photo_template = """
    <div class='photo-wrapper'>
        <img src="{{product_image}}" class="photo">
        <span class='remove btn btn-success'>
            <i class='icon-ok'></i>
        </span>
        <span class='add btn'>
            <i class='icon-plus-sign'></i>
        </span>
    </div>
"""


if gon.page is 'products_new' or gon.page is 'products_create' or gon.page is 'products_edit' or gon.page is 'products_update'
    $ ->
        ($ '#existing_photo_grid').on 'click', '.photo-wrapper', ->
            ($ @).toggleClass('selected')

        ($ '#add_existing_photos').click ->
            $.get '/fetch_instagram_feed_for_user', (_response) ->
                response = JSON.parse(_response)

                unless response.status is 'success'
                    alert 'Sorry, something went wrong.'
                else
                    for product_image in response.product_images
                        img = Mustache.render photo_template, { product_image }
                        $('#existing_photo_grid').append(img)

                    $('#existing_photo_grid_wrapper').removeClass('hide')
                    $('#default_submit_buttons').addClass('hide')


        ($ 'form').submit ->
            alert $('.photo-wrapper.selected').length
