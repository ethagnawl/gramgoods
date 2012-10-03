class User < ActiveRecord::Base
  has_many :stores

  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable, :validatable

  #validates_acceptance_of :tos, :on => :create, :accept => true

  def self.from_omniauth(auth)
    where(auth.slice(:uid, :provider)).first_or_create do |user|
      user.uid = auth.uid
      user.provider = auth.provider
      user.username = auth.info.nickname
      user.thumbnail = auth.info.image
      user.access_token = auth.credentials.token
      user.email = "hoge_#{Time.now.seconds_since_midnight.floor}@hoge.com"
    end
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
    super && provider.blank?
  end

  def email_required?
    super && provider.blank?
  end
end
