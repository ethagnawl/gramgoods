class User < ActiveRecord::Base
  has_many :stores, :dependent => :destroy

  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :street_address_1, :street_address_2,
    :city, :state, :postal_code, :business_name

  validates_uniqueness_of :email

  validates_presence_of :email, :street_address_1, :city, :state, :postal_code

  def self.from_omniauth(auth, user_params, store_params)
    new_user = false
    user = where(auth.slice(:uid)).first_or_create do |user|
      unless user_params.nil? && store_params.nil?
        new_user = true
        user.uid = auth.uid
        user.provider = auth.provider
        user.username = auth.info.nickname
        user.thumbnail = auth.info.image
        user.access_token = auth.credentials.token
        user.email = user_params['email']
        user.business_name = user_params['business_name']
        user.street_address_1 = user_params['street_address_1']
        unless user_params['street_address_2'].nil?
          user.street_address_2 = user_params['street_address_2']
        end
        user.email = user_params['email']
        user.city = user_params['city']
        user.state = user_params['state']
        user.postal_code = user_params['postal_code']
      end
    end.tap { |u| u.create_store store_params if new_user }

    if user_params.nil? && store_params.nil? && user.sign_in_count == 0
      user.delete
      false
    else
      user
    end
  end

  def is_a_new_user?
    self.sign_in_count == 1
  end

  def create_store(store_params)
    self.stores.create store_params
  end

  def store_ids
    Store.find_all_by_user_id(self.id).map { |store| store.id }
  end

  def first_store
    self.stores.first
  end

  def self.new_with_session(params, session)
    if devise_attributes = session['devise.user_attributes']
      new(devise_attributes, :without_protection => true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    false
  end

  def email_required?
    super && provider.blank?
  end

  def update_instagram_cache(tag)
    self.fetch_instagram_feed_for_user_and_filter_by_tag(tag)
  end
  handle_asynchronously :update_instagram_cache, :run_at => Proc.new {
    20.minutes.from_now }

  def fetch_instagram_feed_for_user_and_filter_by_tag(_tag)
    tag = _tag.downcase
    tag = tag.split('#')[1] if /^#+/ =~ tag
    key = "#{self.uid}_#{tag}"
    user_photo_feed_from_cache = Rails.cache.read(key)

    if user_photo_feed_from_cache.nil?
      begin
        Instagram.configure do |config|
          config.client_id = self.uid
          config.access_token = self.access_token
        end
        media_count = (Instagram.user.counts.media).to_i
        last_id = nil
        i = 0
        max_id = nil
        user_photo_feed = []

        begin
          lambda { |r, max_id = nil|
            user_photo_feed.concat(
              Instagram.user_recent_media(:max_id => max_id).tap { |items|
                i += items.length
                last_id = items.last.id
              }.find_all { |item|
                item.tags.member? tag
              }.map { |item|
                {
                  :like_count => item.likes[:count],
                  :url => item.images.standard_resolution.url
                }})
            r.call(r, last_id) if i < media_count
          }.tap { |r| r.call(r) }

        rescue
          puts 'error in lambda'
        end

        unless user_photo_feed.empty?
          begin
            Rails.cache.write key, user_photo_feed, :expires_in => 20.minutes
            self.update_instagram_cache(tag)
          rescue
            puts 'write to cache and fire background job'
          end
        end

        user_photo_feed

      rescue
        puts 'Instagram Connection Error'
      end
    else
      user_photo_feed_from_cache
    end
  end
end
