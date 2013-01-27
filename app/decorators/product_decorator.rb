class ProductDecorator < Draper::Decorator
  delegate_all

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
    def widget(&block)
      h.content_tag :div, class: 'widget' do
        block.call
      end
    end
    def js_void
      'javascript: void(0);'
    end

    def purchase_button
      h.link_to "#{source.purchase_type} #{number_to_currency(source.price)}",
                js_void,
                :class => 'product-button product-purchase',
                :id => 'redirect_to_order_form'
    end
end
