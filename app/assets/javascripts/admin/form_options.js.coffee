window.form_options =
    unhighlight: (label) ->
        $(label).closest('.control-group').removeClass('error')
    highlight: (label) ->
        $(label).closest('.control-group').addClass('error')
    success: (label) ->
        $(label).closest('.control-group').removeClass('error')
