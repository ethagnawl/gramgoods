var happy = {
    USPhone: function (val) {
        return /^\(?(\d{3})\)?[\- ]?\d{3}[\- ]?\d{4}$/.test(val)
    },

    // matches mm/dd/yyyy (requires leading 0's (which may be a bit silly, what do you think?)
    date: function (val) {
        return /^(?:0[1-9]|1[0-2])\/(?:0[1-9]|[12][0-9]|3[01])\/(?:\d{4})/.test(val);
    },

    email: function (val) {
        return /\S@\S/.test(val);
    },

    minLength: function (val, length) {
        return val.length >= length;
    },

    maxLength: function (val, length) {
        return val.length <= length;
    },

    equal: function (val1, val2) {
        return (val1 == val2);
    },

    postal_code: function (postal_code) {
        var postal_code_regex = /(^\d{5}(-\d{4})?$)|(^[ABCEGHJKLMNPRSTVXYabceghjklmnpstvxy]{1}\d{1}[A-Za-z]{1} ?\d{1}[A-Za-z]{1}\d{1})$/;
        return postal_code_regex.test(postal_code);
    },

    credit_card_number: function (credit_card_number) {
        var credit_card_number_regex = /^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$/;
        return credit_card_number_regex.test(credit_card_number);
    },

    is_checked: function (val, el) {
        return $(el).prop('checked') === true;
    },

    is_valid_price: function (val) {
        return /^(\d{1,3}(\,\d{3})*|(\d+))(\.\d{2})?$/.test(val);
    },

    is_valid_quantity: function (val) {
        // first character is 1-9 followed by zero or more 0-9s
        return /^[1-9]{1}[0-9]*$/.test(val);
    },

    is_valid_url: function (val) {
        return /^(http[s]?:\/\/){0,1}(www\.){0,1}[a-zA-Z0-9\.\-]+\.[a-zA-Z]{2,5}[\.]{0,1}/.test(val);
    },

    is_valid_ccv: function (val) {
        return /^[0-9]{3,4}$/.test(val);
    }
};
