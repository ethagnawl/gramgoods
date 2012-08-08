window.templates.billing_form_template = """
<form id='billing_form' class='billing-form' action="">
    <a class='hide-form' href="javascript: void(0);">TODO - X</a>
    <legend>Enter Your Billing Information</legend>
    <fieldset>
        <label for="first_name">First Name*</label>
        <input id="first_name" name="order[first_name]" type="text" />
    </fieldset>
    <fieldset>
        <label for="last_name">Last Name*</label>
        <input id="last_name" name="order[last_name]" type="text" />
    </fieldset>
    <fieldset>
        <label for="credit_card_number">Credit Card Number*</label>
        <input id="credit_card_number" name="order[credit_card_number]" type="text" />
    </fieldset>
    <fieldset>
        <label for="credit_card_expiration">Credit Card Expiration*</label>
        <input id="credit_card_expiration" name="order[credit_card_expiration]" type="text" />
    </fieldset>
    <fieldset>
        <label for="postal_code">Postal Code*</label>
        <input id="postal_code" name="order[postal_code]" type="text" />
    </fieldset>
    <fieldset>
    <input type="submit" value="Submit" />
    </fieldset>
</form>

"""
