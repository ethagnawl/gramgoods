$ ->
    $.ajaxSetup
        timeout: 10000
        error: ->
            alert 'Something went wrong. Please refresh the page and try again.'

    window.spinner = new Spinner {color: '#fff'}
    $.extend window.spinner,
        start       : -> @spin (document.getElementById 'spin')
        $el         : ($ '#spin_wrapper')
        toggleSpinner: ->
            do @["#{(if @spinning then 'stop' else 'start')}"]
            @spinning = !@spinning
            @$el.toggleClass 'hide'

    ($ '#spin_wrapper').bind 'ajaxSend ajaxComplete', ->
        window.spinner.toggleSpinner()


