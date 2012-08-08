window.templates.address_form_template = """
<form id='address_form' class='address-form' action="">
    <a class='hide-form' href="javascript: void(0);">TODO - X</a>
    <legend>Enter Your Shipping Address</legend>
    <fieldset>
        <label for="first_name">First Name*</label>
        <input id="first_name" name="order[first_name]" type="text" />
    </fieldset>
    <fieldset>
        <label for="last_name">Last Name*</label>
        <input id="last_name" name="order[last_name]" type="text" />
    </fieldset>
    <fieldset>
        <label for="street_address_one">Street Address*</label>
        <input id="street_address_one" name="order[street_address_one]" type="text" />
    </fieldset>
    <fieldset>
        <label for="apartment_number">Apartment Number</label>
        <input id="apartment_number" name="order[apartment_number]" type="text" />
    </fieldset>
    <fieldset>
        <label for="city">City*</label>
        <input id="city" name="order[city]" type="text" />
    </fieldset>
    <fieldset>
        <label for="state">State*</label>
        <input id="state" name="order[state]" type="text" />
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
