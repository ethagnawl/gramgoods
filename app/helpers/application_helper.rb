module ApplicationHelper
  def inline_order_summary(order)
      "Order #{order.id} | #{order.line_item.product_name} | #{order.created_at.strftime("%m/%d/%Y")} | #{number_to_currency(order.line_item.total)}"
  end

  def no_products_message(store)
<<eos
What are you waiting for?
<br>
<a href="#{new_store_product_path(store) }"> Create your first product!</a>
eos
  end

  def is_orders_page(store)
    request.path == store_orders_path(store)
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

  #TODO: replace defaults with options hash
  def render_show_product_link(product, text = 'View', classname = nil)
    link_to text, custom_product_path(product.store, product), :class => classname
  end

  def render_edit_product_link(product, text = 'Edit', classname = nil)
    link_to text, custom_product_edit_path(product.store, product),
      :class => classname
  end

  def render_delete_product_link(product, text = 'Delete', classname = nil)
    link_to text, store_product_path(product.store.slug, product.slug),
              :class => classname,
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
    current_year = Time.new.year
    years = [
      ['Expiration Year*', nil],
      [current_year, current_year]
    ]

    (1..10).each do |_year|
      year = current_year + _year
      years << [year, year]
    end

    years
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

  def countries
    [
      ['Country*', ''],
      ["United States", "United States"],
      ["United Kingdom", "United Kingdom"],
      ["Afghanistan", "Afghanistan"],
      ["Albania", "Albania"],
      ["Algeria", "Algeria"],
      ["American Samoa", "American Samoa"],
      ["Andorra", "Andorra"],
      ["Angola", "Angola"],
      ["Anguilla", "Anguilla"],
      ["Antarctica", "Antarctica"],
      ["Antigua and Barbuda", "Antigua and Barbuda"],
      ["Argentina", "Argentina"],
      ["Armenia", "Armenia"],
      ["Aruba", "Aruba"],
      ["Australia", "Australia"],
      ["Austria", "Austria"],
      ["Azerbaijan", "Azerbaijan"],
      ["Bahamas", "Bahamas"],
      ["Bahrain", "Bahrain"],
      ["Bangladesh", "Bangladesh"],
      ["Barbados", "Barbados"],
      ["Belarus", "Belarus"],
      ["Belgium", "Belgium"],
      ["Belize", "Belize"],
      ["Benin", "Benin"],
      ["Bermuda", "Bermuda"],
      ["Bhutan", "Bhutan"],
      ["Bolivia", "Bolivia"],
      ["Bosnia and Herzegovina", "Bosnia and Herzegovina"],
      ["Botswana", "Botswana"],
      ["Bouvet Island", "Bouvet Island"],
      ["Brazil", "Brazil"],
      ["British Indian Ocean Territory", "British Indian Ocean Territory"],
      ["Brunei Darussalam", "Brunei Darussalam"],
      ["Bulgaria", "Bulgaria"],
      ["Burkina Faso", "Burkina Faso"],
      ["Burundi", "Burundi"],
      ["Cambodia", "Cambodia"],
      ["Cameroon", "Cameroon"],
      ["Canada", "Canada"],
      ["Cape Verde", "Cape Verde"],
      ["Cayman Islands", "Cayman Islands"],
      ["Central African Republic", "Central African Republic"],
      ["Chad", "Chad"],
      ["Chile", "Chile"],
      ["China", "China"],
      ["Christmas Island", "Christmas Island"],
      ["Cocos (Keeling) Islands", "Cocos (Keeling) Islands"],
      ["Colombia", "Colombia"],
      ["Comoros", "Comoros"],
      ["Congo", "Congo"],
      ["Congo, The Democratic Republic of The", "Congo, The Democratic Republic of The"],
      ["Cook Islands", "Cook Islands"],
      ["Costa Rica", "Costa Rica"],
      ["Cote D'ivoire", "Cote D'ivoire"],
      ["Croatia", "Croatia"],
      ["Cuba", "Cuba"],
      ["Cyprus", "Cyprus"],
      ["Czech Republic", "Czech Republic"],
      ["Denmark", "Denmark"],
      ["Djibouti", "Djibouti"],
      ["Dominica", "Dominica"],
      ["Dominican Republic", "Dominican Republic"],
      ["Ecuador", "Ecuador"],
      ["Egypt", "Egypt"],
      ["El Salvador", "El Salvador"],
      ["Equatorial Guinea", "Equatorial Guinea"],
      ["Eritrea", "Eritrea"],
      ["Estonia", "Estonia"],
      ["Ethiopia", "Ethiopia"],
      ["Falkland Islands (Malvinas)", "Falkland Islands (Malvinas)"],
      ["Faroe Islands", "Faroe Islands"],
      ["Fiji", "Fiji"],
      ["Finland", "Finland"],
      ["France", "France"],
      ["French Guiana", "French Guiana"],
      ["French Polynesia", "French Polynesia"],
      ["French Southern Territories", "French Southern Territories"],
      ["Gabon", "Gabon"],
      ["Gambia", "Gambia"],
      ["Georgia", "Georgia"],
      ["Germany", "Germany"],
      ["Ghana", "Ghana"],
      ["Gibraltar", "Gibraltar"],
      ["Greece", "Greece"],
      ["Greenland", "Greenland"],
      ["Grenada", "Grenada"],
      ["Guadeloupe", "Guadeloupe"],
      ["Guam", "Guam"],
      ["Guatemala", "Guatemala"],
      ["Guinea", "Guinea"],
      ["Guinea-bissau", "Guinea-bissau"],
      ["Guyana", "Guyana"],
      ["Haiti", "Haiti"],
      ["Heard Island and Mcdonald Islands", "Heard Island and Mcdonald Islands"],
      ["Holy See (Vatican City State)", "Holy See (Vatican City State)"],
      ["Honduras", "Honduras"],
      ["Hong Kong", "Hong Kong"],
      ["Hungary", "Hungary"],
      ["Iceland", "Iceland"],
      ["India", "India"],
      ["Indonesia", "Indonesia"],
      ["Iran, Islamic Republic of", "Iran, Islamic Republic of"],
      ["Iraq", "Iraq"],
      ["Ireland", "Ireland"],
      ["Israel", "Israel"],
      ["Italy", "Italy"],
      ["Jamaica", "Jamaica"],
      ["Japan", "Japan"],
      ["Jordan", "Jordan"],
      ["Kazakhstan", "Kazakhstan"],
      ["Kenya", "Kenya"],
      ["Kiribati", "Kiribati"],
      ["Korea, Democratic People's Republic of", "Korea, Democratic People's Republic of"],
      ["Korea, Republic of", "Korea, Republic of"],
      ["Kuwait", "Kuwait"],
      ["Kyrgyzstan", "Kyrgyzstan"],
      ["Lao People's Democratic Republic", "Lao People's Democratic Republic"],
      ["Latvia", "Latvia"],
      ["Lebanon", "Lebanon"],
      ["Lesotho", "Lesotho"],
      ["Liberia", "Liberia"],
      ["Libyan Arab Jamahiriya", "Libyan Arab Jamahiriya"],
      ["Liechtenstein", "Liechtenstein"],
      ["Lithuania", "Lithuania"],
      ["Luxembourg", "Luxembourg"],
      ["Macao", "Macao"],
      ["Macedonia, The Former Yugoslav Republic of", "Macedonia, The Former Yugoslav Republic of"],
      ["Madagascar", "Madagascar"],
      ["Malawi", "Malawi"],
      ["Malaysia", "Malaysia"],
      ["Maldives", "Maldives"],
      ["Mali", "Mali"],
      ["Malta", "Malta"],
      ["Marshall Islands", "Marshall Islands"],
      ["Martinique", "Martinique"],
      ["Mauritania", "Mauritania"],
      ["Mauritius", "Mauritius"],
      ["Mayotte", "Mayotte"],
      ["Mexico", "Mexico"],
      ["Micronesia, Federated States of", "Micronesia, Federated States of"],
      ["Moldova, Republic of", "Moldova, Republic of"],
      ["Monaco", "Monaco"],
      ["Mongolia", "Mongolia"],
      ["Montserrat", "Montserrat"],
      ["Morocco", "Morocco"],
      ["Mozambique", "Mozambique"],
      ["Myanmar", "Myanmar"],
      ["Namibia", "Namibia"],
      ["Nauru", "Nauru"],
      ["Nepal", "Nepal"],
      ["Netherlands", "Netherlands"],
      ["Netherlands Antilles", "Netherlands Antilles"],
      ["New Caledonia", "New Caledonia"],
      ["New Zealand", "New Zealand"],
      ["Nicaragua", "Nicaragua"],
      ["Niger", "Niger"],
      ["Nigeria", "Nigeria"],
      ["Niue", "Niue"],
      ["Norfolk Island", "Norfolk Island"],
      ["Northern Mariana Islands", "Northern Mariana Islands"],
      ["Norway", "Norway"],
      ["Oman", "Oman"],
      ["Pakistan", "Pakistan"],
      ["Palau", "Palau"],
      ["Palestinian Territory, Occupied", "Palestinian Territory, Occupied"],
      ["Panama", "Panama"],
      ["Papua New Guinea", "Papua New Guinea"],
      ["Paraguay", "Paraguay"],
      ["Peru", "Peru"],
      ["Philippines", "Philippines"],
      ["Pitcairn", "Pitcairn"],
      ["Poland", "Poland"],
      ["Portugal", "Portugal"],
      ["Puerto Rico", "Puerto Rico"],
      ["Qatar", "Qatar"],
      ["Reunion", "Reunion"],
      ["Romania", "Romania"],
      ["Russian Federation", "Russian Federation"],
      ["Rwanda", "Rwanda"],
      ["Saint Helena", "Saint Helena"],
      ["Saint Kitts and Nevis", "Saint Kitts and Nevis"],
      ["Saint Lucia", "Saint Lucia"],
      ["Saint Pierre and Miquelon", "Saint Pierre and Miquelon"],
      ["Saint Vincent and The Grenadines", "Saint Vincent and The Grenadines"],
      ["Samoa", "Samoa"],
      ["San Marino", "San Marino"],
      ["Sao Tome and Principe", "Sao Tome and Principe"],
      ["Saudi Arabia", "Saudi Arabia"],
      ["Senegal", "Senegal"],
      ["Serbia and Montenegro", "Serbia and Montenegro"],
      ["Seychelles", "Seychelles"],
      ["Sierra Leone", "Sierra Leone"],
      ["Singapore", "Singapore"],
      ["Slovakia", "Slovakia"],
      ["Slovenia", "Slovenia"],
      ["Solomon Islands", "Solomon Islands"],
      ["Somalia", "Somalia"],
      ["South Africa", "South Africa"],
      ["South Georgia and The South Sandwich Islands", "South Georgia and The South Sandwich Islands"],
      ["Spain", "Spain"],
      ["Sri Lanka", "Sri Lanka"],
      ["Sudan", "Sudan"],
      ["Suriname", "Suriname"],
      ["Svalbard and Jan Mayen", "Svalbard and Jan Mayen"],
      ["Swaziland", "Swaziland"],
      ["Sweden", "Sweden"],
      ["Switzerland", "Switzerland"],
      ["Syrian Arab Republic", "Syrian Arab Republic"],
      ["Taiwan, Province of China", "Taiwan, Province of China"],
      ["Tajikistan", "Tajikistan"],
      ["Tanzania, United Republic of", "Tanzania, United Republic of"],
      ["Thailand", "Thailand"],
      ["Timor-leste", "Timor-leste"],
      ["Togo", "Togo"],
      ["Tokelau", "Tokelau"],
      ["Tonga", "Tonga"],
      ["Trinidad and Tobago", "Trinidad and Tobago"],
      ["Tunisia", "Tunisia"],
      ["Turkey", "Turkey"],
      ["Turkmenistan", "Turkmenistan"],
      ["Turks and Caicos Islands", "Turks and Caicos Islands"],
      ["Tuvalu", "Tuvalu"],
      ["Uganda", "Uganda"],
      ["Ukraine", "Ukraine"],
      ["United Arab Emirates", "United Arab Emirates"],
      ["United Kingdom", "United Kingdom"],
      ["United States", "United States"],
      ["United States Minor Outlying Islands", "United States Minor Outlying Islands"],
      ["Uruguay", "Uruguay"],
      ["Uzbekistan", "Uzbekistan"],
      ["Vanuatu", "Vanuatu"],
      ["Venezuela", "Venezuela"],
      ["Viet Nam", "Viet Nam"],
      ["Virgin Islands, British", "Virgin Islands, British"],
      ["Virgin Islands, U.S.", "Virgin Islands, U.S."],
      ["Wallis and Futuna", "Wallis and Futuna"],
      ["Western Sahara", "Western Sahara"],
      ["Yemen", "Yemen"],
      ["Zambia", "Zambia"],
      ["Zimbabwe", "Zimbabwe"],
    ]
  end

  def custom_merchant_logo_src(store_slug)
    "//s3.amazonaws.com/gramgoods-production/#{store_slug}.jpg"
  end

  def custom_merchant_css_class(store_slug)
    if is_store_slug_in_merchants_with_custom_store_slugs_array?(store_slug)
      " custom-merchant-#{store_slug}"
    else
      ' non-custom-merchant'
    end
  end

  def custom_merchant_css_class_for_product(store_slug)
    custom_css_class = custom_merchant_css_class(store_slug)
    custom_css_class << '-product' unless custom_css_class.empty?
  end
end
