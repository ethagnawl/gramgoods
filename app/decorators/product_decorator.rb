class ProductDecorator < Draper::Decorator
  delegate_all

  def header
    if source.belongs_to_customized_store?
      h.content_tag :span, class: 'mobile-header-store-logo' do
        h.content_tag(:a, href: h.custom_store_path(source.store), title: source.store.name) do
          h.image_tag(h.custom_merchant_logo_src(source.store.slug),
                      :alt => source.store.name)
        end
      end
    else
      source.name
    end
  end

  def thumbnail_gallery
    h.render 'products/thumbnail_gallery', locals: {
      product_name: source.name,
      product_images: source.get_product_images
    }
  end

  def customized_store_body_header
    if source.belongs_to_customized_store?
      widget(class: 'product-name') do
        h.content_tag(:h3, source.name)
      end
    end
  end

  def merchant
    widget do
      h.content_tag(:h3, 'Merchant') +
      h.content_tag(:p, 'Merchant') do
        h.link_to(source.store.name, h.custom_store_path(source.store))+
        h.content_tag(:span, ' | ') +
        h.link_to('Return Policy', h.return_policy_store_path(source.store))
      end
    end
  end

  def description(passthrough = false)
    if passthrough
      source.description
    else
      widget do
        h.content_tag(:h3, 'Description') +
        h.content_tag(:p, source.description)
      end
    end
  end

  def quantity
    if source.is_purchasable?
      widget do
        h.content_tag(:h3, 'Quantity') +
        if source.unlimited_quantity
          h.text_field(:product, :quantity,
                      id: 'quantity',
                      type: 'tel',
                      class: 'input-xxlarge',
                      value: nil,
                      placeholder: 'Enter Quantity')
        else
          h.select_tag(:quantity, h.options_for_select(
            (1..source.quantity.to_i).each { |n| [n,n] }))
        end
      end
    end
  end

  def colors
    has_many_widget('colors') if source.is_purchasable?
  end

  def sizes
    has_many_widget('sizes') if source.is_purchasable?
  end

  def flatrate_shipping_options
    h.render 'flatrate_shipping_options', locals: { product: source }
  end

  def purchase_button_or_status_message
    if source.is_purchasable?
      purchase_button
    else
      widget do
        message = case source.status
          when 'Draft' then 'This product will not be visible to customers until you change its status to Active or Out of Stock.'
          when 'Out of Stock' then 'This product is currently Out of Stock.'
          else ''
        end

        h.content_tag(:h3, 'Product Status') +
        h.content_tag(:p, message)
      end
    end
  end

  private
    def widget(options = {}, &block)
      widget_class = 'widget'
      widget_class << " #{options[:class]}" unless options[:class].nil?

      h.content_tag :div, class: widget_class do
        block.call
      end
    end

    def js_void
      'javascript: void(0);'
    end

    def purchase_button
      h.link_to "#{source.purchase_type.titleize} #{number_to_currency(source.price)}",
                js_void,
                :class => 'product-button product-purchase',
                :id => 'redirect_to_order_form'
    end

    def has_many_widget(association_name)
      association_name_singular = association_name.singularize
      association_collection = source.send(association_name)
      unless association_collection.nil? || association_collection.empty?
        widget do
          if association_collection.length == 1
            value = association_collection.first.send(association_name_singular)
            h.content_tag(:h3, association_name_singular.humanize) +
            h.content_tag(:p, value) +
            h.hidden_field(:product, association_name_singular.to_sym, value: value, id: association_name_singular)
          else
            h.content_tag(:h3, association_name.humanize) +
            h.select_tag(association_name_singular.to_sym, h.options_for_select(
              association_collection.map do |association|
                [
                  association.send(association_name_singular),
                  association.send(association_name_singular)
                ]
              end
            ), id: association_name_singular, class: 'input-xxlarge')
          end
        end
      end
    end
end
