module ApplicationHelper
  def configure_instagram(client_key, access_token)
    Instagram.configure do |config|
      config.client_id = client_key
      config.access_token = access_token
    end
  end

  # TODO move into jbuilder partial
  def render_user_photo_template(product = nil, photo)
    selected = product.nil? ? false : product.product_image_ids.include?(photo.instagram_id)
    {
      :url => photo.url ||= view_context.product_photo_url(photo),
      :instagram_id => photo.id,
      :tags => photo.tags,
      :selected => selected ? 'selected' : nil,
      :btnClass => selected ? 'btn-success' : 'btn-inverse'
    }
  end

  def get_instagram_photo_feed_for_user(user, max_id = nil)
    begin
      configure_instagram(user.authentication.uid, user.authentication.access_token)
      user_photo_feed = Instagram.user_recent_media({ :max_id => max_id})
      Instagram.reset
      user_photo_feed
    rescue
      puts 'Instagram Connection Error'
    end
  end

  def us_states
    [
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
