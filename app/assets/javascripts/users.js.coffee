if gon.page is 'registrations_new' or gon.page is 'registrations_edit'
    $ ->
        ($ '#registrations_form_wrapper').find('form').validate user_form_options
