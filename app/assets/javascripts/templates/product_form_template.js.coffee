window.product_form_template = """
    <form method="post"
    {{#put}}id="edit_product_{{slug}}"{{/put}}
    {{^put}}id="new_product"{{/put}}
    class="well form-horizontal" action="/stores/{{storeSlug}}/products/{{slug}}">
        <a href="javascript: void(0);" class="refresh-form gramgoods-tooltip" title='reset form'>
            <i class="icon-refresh"></i>
        </a>
        {{#put}}
        <input type="hidden" value="put" name="_method">
        {{/put}}
        <div class="form-errors-wrapper"></div>
        <fieldset class="float-left">
            <div class="control-group">
                <label class='control-label' for="product_name">Name*</label>
                <div class="controls">
                    <input type="text" value="{{name}}" size="30" name="product[name]" id="product_name" class="input-xlarge">
                </div>
            </div>
            <div class="control-group">
                <label class='control-label' for="product_instagram_tag">Instagram Tag*</label>
                <div class="controls">
                  <div class="input-prepend">
                      <span class="add-on">#</span>
                      <input type="text" value="{{instagramTag}}" size="30" name="product[instagram_tag]" id="product_instagram_tag" class="input-xlarge">
                  </div>
                </div>
            </div>
            <div class="control-group">
                <label class='control-label' for="product_description">Description*</label>
                <div class="controls">
                    <textarea rows="5" name="product[description]" id="product_description" cols="40" class="input-xlarge">{{description}}</textarea>
                </div>
            </div>
            <div class="control-group">
              <label class='control-label' for="product_price">Price*</label>
              <div class="controls">
                  <div class="input-prepend">
                      <span class="add-on">$</span>
                      <input type="text" value="{{price}}" size="30" name="product[price]" id="product_price" class="input-xlarge">
                  </div>
              </div>
            </div>
        </fieldset>
        <fieldset class='float-left'>
            <div class="control-group">
                <label class='control-label' for="product_quantity">Quantity*</label>
                <div class="controls">
                    <input type="text" value="{{^unlimitedQuantity}}{{quantity}}{{/unlimitedQuantity}}" size="30" name="product[quantity]" id="product_quantity" {{#unlimitedQuantity}}disabled="disabled"{{/unlimitedQuantity}} class="input-xlarge">
                </div>
            </div>
            <div class="control-group">
                <label class='control-label' for="product_unlimited_quantity">Unlimited Quantity</label>
                <div class="controls">
                    <input type="hidden" value="0" name="product[unlimited_quantity]">
                    <input type='checkbox' value="1" name="product[unlimited_quantity]" id="product_unlimited_quantity" {{#unlimitedQuantity}} checked='checked' {{/unlimitedQuantity}} class='product-unlimited-quantity'>
                </div>
            </div>
            <div class="control-group">
                <label class='control-label' for="product_colors">Colors</label>
                <div class="controls">
                    <input type="text" value="{{colors}}" size="30" name="product[colors]" id="product_colors" class="input-xlarge">
                </div>
              </div>
            <div class="control-group">
                <label class='control-label' for="product_sizes">Sizes</label>
                <div class="controls">
                    <input type="text" value="{{sizes}}" size="30" name="product[sizes]" id="product_sizes" class="input-xlarge">
                </div>
            </div>
            <div class="control-group">
                <label class='control-label' for="product_flatrate_shipping_cost">Flatrate shipping cost</label>
                <div class="controls">
                  <div class="input-prepend">
                      <span class="add-on">$</span>
                      <input type="text" value="{{flatrateShippingCost}}" size="30" name="product[flatrate_shipping_cost]" id="product_flatrate_shipping_cost" class="input-xlarge">
                  </div>
                </div>
            </div>
            <div class="control-group">
                <label class='control-label' for="product_status">Status</label>
                <div class="controls">
                    <select name="product[status]" id="product_status">
                    <option {{#draft}}selected="selected"{{/draft}} value="Draft">Draft</option>
                    <option {{#active}}selected="selected"{{/active}} value="Active">Active</option>
                    <option {{#outOfStock}}selected="selected"{{/outOfStock}} value='Out of Stock'>Out of Stock</option>
                    </select>
                </div>
            </div>
            </fieldset>

            {{#put}}
            <fieldset class="widget">
                <div class="control-group">
                    <h2>Product Photos</h2>
                    <div class="product-photos">Loading photos...</div>
                </div>
            </fieldset>
            {{/put}}

            <fieldset class="widget">
                <div class="control-group">
                    <h2>Your Photo Feed</h2>
                    <div class="photo-feed">Loading photos...</div>
                </div>
            </fieldset>
            <div class="form-actions widget">
                {{#put}}
                    <input type="submit" value="Update Product" name="commit" class="btn btn-primary">
                {{/put}}
                {{^put}}
                    <input type="submit" value="Create Product" name="commit" class="btn btn-primary">
                {{/put}}
            </div>
        </fieldset>
    </form>
"""
