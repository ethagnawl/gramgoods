window.templates.order_form_template = """
<form id='order_form' class='order-form' action="">
    <a class='hide-form' href="javascript: void(0);">TODO - X</a>
    <fieldset>
        <h1>{{product_name}}</h1>
    </fieldset>

    {{#quantity}}
        <fieldset>
            <p>
                Quantity: {{quantity}}
                <a class='edit-quantity' href="javascript: void(0);">edit</a>
            </p>
            <input type="hidden" value="{{quantity}}" name="order[line_items_attributes][0][quantity]">
        </fieldset>
    {{/quantity}}

    {{#size}}
        <fieldset>
            <p>
                Size: {{size}}
                <a class='edit-size' href="javascript: void(0);">edit</a>
            </p>
            <input type="hidden" value="{{size}}" name="order[line_items_attributes][0][size]">
        </fieldset>
    {{/size}}

    {{#color}}
        <fieldset>
            <p>
                Color: {{color}}
                <a class='edit-color' href="javascript: void(0);">edit</a>
            </p>
            <input type="hidden" value="{{color}}" name="order[line_items_attributes][0][color]">
        </fieldset>
    {{/color}}

    <fieldset>
        <p>Price: {{price}}</p>
        <input type="hidden" value="{{price}}" name="order[line_items_attributes][0][price]">
    </fieldset>

    <fieldset>
        <p>Total: {{total}}</p>
        <input type="hidden" value="{{total}}" name="order[line_items_attributes][0][total]">
    </fieldset>

    <fieldset>
        <label for="first_name">First Name*</label>
        <input id="first_name" name="order[recipient_attributes][first_name]" type="text" />
    </fieldset>
    <fieldset>
        <label for="last_name">Last Name*</label>
        <input id="last_name" name="order[recipient_attributes][last_name]" type="text" />
    </fieldset>
    <fieldset>
        <label for="email_address">Email Address*</label>
        <input id="email_address" name="order[recipient_attributes][email_address]" type="text" />
    </fieldset>
    <fieldset>
        <label for="street_address_one">Street Address*</label>
        <input id="street_address_one" name="order[recipient_attributes][street_address_one]" type="text" />
    </fieldset>
    <fieldset>
        <label for="apartment_number">Apartment Number</label>
        <input id="street_address_two" name="order[recipient_attributes][street_address_two]" type="text" />
    </fieldset>
    <fieldset>
        <label for="city">City*</label>
        <input id="city" name="order[recipient_attributes][city]" type="text" />
    </fieldset>
    <fieldset>
        <label for="state">State*</label>
        <input id="state" name="order[recipient_attributes][state]" type="text" />
    </fieldset>
    </fieldset>
    <fieldset>
        <label for="postal_code">Postal Code*</label>
        <input id="postal_code" name="order[recipient_attributes][postal_code]" type="text" />
    </fieldset>
    <fieldset>
        <label for="credit_card_number">Credit Card Number*</label>
        <input id="credit_card_number" type="text" />
    </fieldset>
    <fieldset>
        <label for="credit_card_expiration_month">Credit Card Expiration Month (MM)*</label>
        <input id="credit_card_expiration_month" type="text" />
    </fieldset>
    <fieldset>
        <label for="credit_card_expiration_year">Credit Card Expiration Year (YYYY)*</label>
        <input id="credit_card_expiration_year" type="text" />
    </fieldset>
    <fieldset>
        <input type="submit" value="Submit" />
    </fieldset>
</form>
"""
