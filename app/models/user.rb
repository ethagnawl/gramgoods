class User < ActiveRecord::Base
  has_many :stores
  has_one :authentication

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation,
    :remember_me, :first_name, :last_name, :website,
    :business_name, :street_address_1, :street_address_2, :city, :state,
    :postal_code, :phone_number

  validates_presence_of :first_name, :last_name, :business_name, :website,
    :street_address_1, :city, :state, :postal_code, :phone_number

  validates_format_of :website, :with => /^(http[s]?:\/\/){0,1}(www\.){0,1}[a-zA-Z0-9\.\-]+\.[a-zA-Z]{2,5}[\.]{0,1}/
  validates_format_of :postal_code, :message => 'must be a valid Postal Code.', :with => /^([0-9]{5}(?:-[0-9]{4})?)*$/
  validates_format_of :phone_number, :message => "must be a valid telephone number.", :with => /^[\(\)0-9\- \+\.]{10,20}$/

  def apply_omniauth(omniauth)
    authentications.build(
      :provider => omniauth['provider'],
      :uid => omniauth['uid'],
      :access_token => omniauth['credentials']['token'])
  end

  def password_required?
    super
  end

  def store_ids
    Store.find_all_by_user_id(self.id).map { |store| store.id }
  end
end
