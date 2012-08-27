window.templates = {}

$ ->
    $.ajaxSetup
        dataType: 'json'
        timeout: 10000
        error: ->
            alert 'Something went wrong. Please refresh the page and try again.'

    window.hide = 'hide'
    window.$window = ($ window)
    window.$product_form_wrapper = ($ '#product_form_wrapper')

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

    $.validator.addMethod("phoneUS", (phone_number, element) ->
        phone_number = phone_number.replace(/\s+/g, "")
        return this.optional(element) || phone_number.length > 9 && phone_number.match(/^(1-?)?(\([2-9]\d{2}\)|[2-9]\d{2})-?[2-9]\d{2}-?\d{4}$/)
    , "Please specify a valid phone number")

    $.validator.addMethod("postalCode", (postal_code, element) ->
        return this.optional(element) || postal_code.match(/(^\d{5}(-\d{4})?$)|(^[ABCEGHJKLMNPRSTVXYabceghjklmnpstvxy]{1}\d{1}[A-Za-z]{1} ?\d{1}[A-Za-z]{1}\d{1})$/)
    , "Please specify a valid postal code")

    $.validator.addMethod("decimalTwo", (value, element) ->
        this.optional(element) or /^(\d+)(\.\d{1,2})?$/.test(value) && value > 0
    , "Must be in US currency format 0.99")

    # override jquery.validation's url method, which requires protocol
    $.validator.addMethod("url", (value, element) ->
        this.optional(element) or /^(http[s]?:\/\/){0,1}(www\.){0,1}[a-zA-Z0-9\.\-]+\.[a-zA-Z]{2,5}[\.]{0,1}/.test(value)
    , "Must be a valid URL")
