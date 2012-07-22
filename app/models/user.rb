class User < ActiveRecord::Base
  has_many :stores
  has_many :authentications

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :email, :password, :password_confirmation,
    :remember_me, :name, :website, :thumbnail

  def apply_omniauth(omniauth)
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :access_token => omniauth['credentials']['token'])
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def self.store_ids
    Store.find_all_by_user_id(self.id).map { |store| store.id }
  end
end
