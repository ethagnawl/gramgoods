class User < ActiveRecord::Base
  has_many :stores, :dependent => :destroy

  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  attr_accessible :email

  before_save :ensure_authentication_token

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
end
