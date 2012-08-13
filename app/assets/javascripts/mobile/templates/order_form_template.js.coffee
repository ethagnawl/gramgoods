window.templates.order_form_template = """
<form id='order_form' class='order-form' action="">
    <div>
        <legend>Order Details</legend>

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

        {{#flatrate_shipping_cost}}
            <fieldset>
                <p>Flat Rate Shipping Cost: ${{flatrate_shipping_cost}}</p>
                <input type="hidden" value="{{flatrate_shipping_cost}}" name="order[line_items_attributes][0][flatrate_shipping_cost]">
            </fieldset>
        {{/flatrate_shipping_cost}}

        <fieldset>
            <p>Price: ${{price}}</p>
            <input type="hidden" value="{{price}}" name="order[line_items_attributes][0][price]">
        </fieldset>

        <fieldset>
            <p><strong>Total: ${{total}}</strong></p>
            <input type="hidden" value="{{total}}" name="order[line_items_attributes][0][total]">
        </fieldset>
    </div>

    <div>
        <legend>Shipping Information</legend>
        <fieldset>
            <input id="first_name" name="order[recipient_attributes][first_name]" type="text" placeholder="First Name*" />
        </fieldset>
        <fieldset>
            <input id="last_name" name="order[recipient_attributes][last_name]" type="text" placeholder="Last Name*" />
        </fieldset>
        <fieldset>
            <input id="email_address" name="order[recipient_attributes][email_address]" type="email" placeholder="E-Mail Address*" />
        </fieldset>
        <fieldset>
            <input id="street_address_one" name="order[recipient_attributes][street_address_one]" type="text" placeholder="Street Address*" />
        </fieldset>
        <fieldset>
            <input id="street_address_two" name="order[recipient_attributes][street_address_two]" type="text" placeholder="Apartment Number" />
        </fieldset>
        <fieldset>
            <input id="city" name="order[recipient_attributes][city]" type="text" placeholder="City*" />
        </fieldset>
        <fieldset>
            <select id="state" name="order[recipient_attributes][state]">
                <option disabled>State*</option>
                <option value="AL">Alabama</option>
                <option value="AK">Alaska</option>
                <option value="AZ">Arizona</option>
                <option value="AR">Arkansas</option>
                <option value="CA">California</option>
                <option value="CO">Colorado</option>
                <option value="CT">Connecticut</option>
                <option value="DE">Delaware</option>
                <option value="DC">District of Columbia</option>
                <option value="FL">Florida</option>
                <option value="GA">Georgia</option>
                <option value="HI">Hawaii</option>
                <option value="ID">Idaho</option>
                <option value="IL">Illinois</option>
                <option value="IN">Indiana</option>
                <option value="IA">Iowa</option>
                <option value="KS">Kansas</option>
                <option value="KY">Kentucky</option>
                <option value="LA">Louisiana</option>
                <option value="ME">Maine</option>
                <option value="MD">Maryland</option>
                <option value="MA">Massachusetts</option>
                <option value="MI">Michigan</option>
                <option value="MN">Minnesota</option>
                <option value="MS">Mississippi</option>
                <option value="MO">Missouri</option>
                <option value="MT">Montana</option>
                <option value="NE">Nebraska</option>
                <option value="NV">Nevada</option>
                <option value="NH">New Hampshire</option>
                <option value="NJ">New Jersey</option>
                <option value="NM">New Mexico</option>
                <option value="NY">New York</option>
                <option value="NC">North Carolina</option>
                <option value="ND">North Dakota</option>
                <option value="OH">Ohio</option>
                <option value="OK">Oklahoma</option>
                <option value="OR">Oregon</option>
                <option value="PA">Pennsylvania</option>
                <option value="PR">Puerto Rico</option>
                <option value="RI">Rhode Island</option>
                <option value="SC">South Carolina</option>
                <option value="SD">South Dakota</option>
                <option value="TN">Tennessee</option>
                <option value="TX">Texas</option>
                <option value="UT">Utah</option>
                <option value="VT">Vermont</option>
                <option value="VA">Virginia</option>
                <option value="WA">Washington</option>
                <option value="WV">West Virginia</option>
                <option value="WI">Wisconsin</option>
                <option value="WY">Wyoming</option>
            </select>
        </fieldset>
        <fieldset>
            <input id="postal_code" name="order[recipient_attributes][postal_code]" type="text" placeholder="Postal Code*" />
        </fieldset>
    </div>

    <div>
    	<legend>Billing Information</legend>
        <fieldset>
            <input id="credit_card_number" type="tel" placeholder="Credit Card Number*" />
        </fieldset>
        <fieldset>
            <select id="credit_card_expiration_month">
                <option>Expiration Month*</option>
                <option value="01">01 - January</option>
                <option value="02">02 - February</option>
                <option value="03">03 - March</option>
                <option value="04">04 - April</option>
                <option value="05">05 - May</option>
                <option value="06">06 - June</option>
                <option value="07">07 - July</option>
                <option value="08">08 - August</option>
                <option value="09">09 - September</option>
                <option value="10">10 - October</option>
                <option value="11">11 - November</option>
                <option value="12">12 - December</option>
            </select>
        </fieldset>
        <fieldset>
            <select id="credit_card_expiration_year">
                <option>Expiration Year*</option>
                <option value="2012">2012</option>
                <option value="2013">2013</option>
                <option value="2014">2014</option>
                <option value="2015">2015</option>
                <option value="2016">2016</option>
                <option value="2017">2017</option>
                <option value="2018">2018</option>
                <option value="2019">2019</option>
                <option value="2020">2020</option>
            </select>
        </fieldset>
        <fieldset>
            <input type="submit" value="Submit" />
        </fieldset>
    </div>
</form>
"""
