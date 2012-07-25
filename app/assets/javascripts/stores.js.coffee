if gon.page is 'stores_show'
    ($ '#new_product').submit (e)->
        e.preventDefault()
        data = ($ @).serialize()
        console.log data
        $.post '/products/new', data, (response) -> console.log response
