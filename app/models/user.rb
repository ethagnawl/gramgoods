class User < ActiveRecord::Base
  include GramGoods::Instagram

  has_many :stores, :dependent => :destroy

  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :business_name, :first_name, :last_name, :email, :phone_number,
    :street_address_1, :street_address_2, :city, :state, :postal_code

  validates_uniqueness_of :email

  validates_presence_of :business_name, :first_name, :last_name, :email, :phone_number,
    :street_address_1, :city, :state, :postal_code

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
        user.first_name = user_params['first_name']
        user.last_name = user_params['last_name']
        user.street_address_1 = user_params['street_address_1']
        unless user_params['street_address_2'].nil?
          user.street_address_2 = user_params['street_address_2']
        end
        user.email = user_params['email']
        user.phone_number = user_params['phone_number']
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
    Store.where(user_id: self.id).map &:id
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
