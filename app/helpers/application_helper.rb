module ApplicationHelper
  def configure_instagram(client_key, access_token)
    Instagram.configure do |config|
      config.client_id = client_key
      config.access_token = access_token
    end
  end

  def conditional_layout_link(params, url)
    if !params[:layout].nil? && params[:layout] == 'mobile'
      url + '?layout=mobile'
    else
      url
    end
  end

  def get_instagram_photo_feed_for_user(user, max_id = nil)
    begin
      configure_instagram(user.uid, user.access_token)
      user_photo_feed = Instagram.user_recent_media({ :max_id => max_id})
      Instagram.reset
      user_photo_feed
    rescue
      puts 'Instagram Connection Error'
    end
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
