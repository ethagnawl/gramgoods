templates.product_form_template = """
    <form method="post"

    {{#put}}id="edit_product_{{slug}}"{{/put}}
    {{^put}}id="new_product"{{/put}}

    class="well form-horizontal" action="/stores/{{storeSlug}}/products/{{slug}}">
        <a href="javascript: void(0);" class="hide-product-form gramgoods-tooltip" title='hide product form'>
            <i class="icon-remove-sign"></i>
        </a>

        {{#put}}
            <input type="hidden" value="put" Name="_method">
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
                        <input placeholder='Enter tag and click + to link your photos' type="text" value="{{instagramTag}}" size="30" name="product[instagram_tag]" id="product_instagram_tag" class="input-xlarge">
                        <span class="help-inline">
                            <a class='add-instagram-tag add-product-form-label' href="javascript: void(0);" title='Click to link photos from your photo feed'>
                                <i class='gramgoods-tooltip icon-plus'></i>
                            </a>
                        </span>
                    </div>
                </div>
                {{#instagram_tags}}
                    {{> product_form_label_template}}
                {{/instagram_tags}}
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
                        <input type="text" value="{{raw_price}}" size="30" name="product[price]" id="product_price" class="input-xlarge">
                    </div>
                </div>
            </div>
        </fieldset>
        <fieldset class='float-left'>
            <div class="control-group">
                <label class='control-label' for="product_quantity">Quantity*</label>
                <div class="controls">
                    <input type="text" value="{{^unlimited_quantity}}{{quantity}}{{/unlimited_quantity}}" size="30" name="product[quantity]" id="product_quantity" {{#unlimited_quantity}}disabled="disabled"{{/unlimited_quantity}} class="input-xlarge">
                </div>
            </div>
            <div class="control-group">
                <label class='control-label' for="product_unlimited_quantity">Unlimited Quantity</label>
                <div class="controls">
                    <input type="hidden" value="0" name="product[unlimited_quantity]">
                    <input type='checkbox' value="1" name="product[unlimited_quantity]" id="product_unlimited_quantity" {{#unlimited_quantity}} checked='checked' {{/unlimited_quantity}} class='product-unlimited-quantity'>
                </div>
            </div>
            <div class="control-group">
                <label class='control-label' for="product_colors">Colors</label>
                <div class="controls">
                    <input placeholder='Enter a color and click +' type="text" size="30" name="product[colors]" id="product_colors" class="input-xlarge">
                        <span class="help-inline">
                            <a class='add-color add-product-form-label' href="javascript: void(0);">
                                <i class='gramgoods-tooltip icon-plus'></i>
                            </a>
                        </span>
                </div>
                {{#colors}}
                    {{> product_form_label_template}}
                {{/colors}}
            </div>
            <div class="control-group">
                <label class='control-label' for="product_sizes">Sizes</label>
                <div class="controls">
                    <input placeholder='Enter a size and click +' type="text" size="30" name="product[sizes]" id="product_sizes" class="input-xlarge">
                      <span class="help-inline">
                          <a class='add-size add-product-form-label' href="javascript: void(0);">
                              <i class='gramgoods-tooltip icon-plus'></i>
                          </a>
                      </span>
                </div>
                {{#sizes}}
                    {{> product_form_label_template}}
                {{/sizes}}
            </div>
            <div class="control-group">
                <label class='control-label' for="product_flatrate_shipping_cost">Flatrate shipping cost</label>
                <div class="controls">
                    <div class="input-prepend">
                        <span class="add-on">$</span>
                        <input type="text" value="{{raw_flatrate_shipping_cost}}" size="30" name="product[flatrate_shipping_cost]" id="product_flatrate_shipping_cost" class="input-xlarge">
                    </div>
                </div>
            </div>
            <div class="control-group">
                <label class='control-label' for="product_status">Status</label>
                <div class="controls">
                    <select name="product[status]" id="product_status" class='input-xlarge'>
                    <option {{#draft}}selected="selected"{{/draft}} value="Draft">Draft</option>
                    <option {{#active}}selected="selected"{{/active}} value="Active">Active</option>
                    <option {{#outOfStock}}selected="selected"{{/outOfStock}} value='Out of Stock'>Out of Stock</option>
                    </select>
                </div>
            </div>
            </fieldset>

            <fieldset class="widget">
                    <div class="widget">
                        <label class='widget' for="share_copy">
                            The following text will be e-mailed to you for easy mobile sharing.
                        </label>
                        <input
                            class='input-xxlarge uneditable-input widget'
                            disabled=disabled
                            id="share_copy"
                            type="text"
                            {{#dummy_share_text}}
                            value="{{dummy_share_text}}"
                            {{/dummy_share_text}}
                            {{^dummy_share_text}}
                            value="Buy {{name}} for {{price}} right now by visiting @{{store_owner_instagram}} or clicking this link: http://gramgoods.com/{{storeSlug}}/{{slug}}"
                            {{/dummy_share_text}}
                        />
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
