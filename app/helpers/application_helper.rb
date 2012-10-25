module ApplicationHelper
  def no_products_message(store)
<<eos
Welcome to GramGoods!
<br>
Get started by <a href="#{new_store_product_path(store) }"> creating your first product</a>.
eos
  end

  def is_edit_product_page(product)
    request.path == custom_product_edit_path(product.store, product)
  end

  def is_edit_store_page(store)
    request.path == custom_store_edit_path(store)
  end

  def is_create_product_page
    "#{params[:controller]}_#{params[:action]}" == 'products_new'
  end

  def is_user_store_page(store)
      request.path == custom_store_path(store)
  end

  def product_status_class(product)
    if product.status == 'Active'
      'btn-success'
    elsif product.status == 'Draft'
      'btn-warning'
    else
      'btn-danger'
    end
  end

  def render_show_product_link(product, text = 'View')
    link_to text, custom_product_path(product.store, product)
  end

  def render_edit_product_link(product, text = 'Edit')
    link_to text, custom_product_edit_path(product.store, product)
  end

  def render_delete_product_link(product, text = 'Delete')
    link_to text, store_product_path(product.store.slug, product.slug),
              :method => :delete,
              :confirm => "Are you sure you want to delete #{product.name}?"
  end

  def random_number
    random = Random.new.rand(20..30)
    Time.now.seconds_since_midnight.floor * random
  end

  def required_form_label(name)
    name << '*'
  end

  def form_label(name, required_field = true, message = nil)
    _label = name.titleize
    _label = required_form_label(_label) unless required_field == false
    _label << message unless message.nil?
    _label
  end

  def credit_card_months
    [
      ['Expiration Month*', nil],
      ["01 - January", "01"],
      ["02 - February", "02"],
      ["03 - March", "03"],
      ["04 - April", "04"],
      ["05 - May", "05"],
      ["06 - June", "06"],
      ["07 - July", "07"],
      ["08 - August", "08"],
      ["09 - September", "09"],
      ["10 - October", "10"],
      ["11 - November", "11"],
      ["12 - December", "12"]
    ]
  end

  def credit_card_years
    [
      ['Expiration Year*', nil],
      [2012, 2012],
      [2013, 2013],
      [2014, 2014],
      [2015, 2015],
      [2016, 2016],
      [2017, 2017],
      [2018, 2018],
      [2019, 2019],
      [2020, 2020]
    ]
  end

  def us_states
    [
      ['State*', ''],
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
  end
end
