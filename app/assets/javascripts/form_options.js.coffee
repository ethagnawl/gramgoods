window.form_options =
    highlight: (label) ->
        $(label).closest('.control-group').addClass('error')
    success: (label) ->
        if ($ label).closest('.control-group').hasClass('error')
            $(label).closest('.control-group').removeClass('error')
