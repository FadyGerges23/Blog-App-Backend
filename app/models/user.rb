class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self,
         authentication_keys: [:email_or_username]

  validates :username, presence: true, uniqueness: true
  validate :username_is_alphanumeric

  attr_accessor :email_or_username

  def email_or_username
    @email_or_username || email || username
  end

  private

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    email_or_username = conditions.delete(:email_or_username)

    if email_or_username
      where(conditions.to_h).where(["username = :value OR email = :value", { value: email_or_username }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions).first
    end
  end

  def username_is_alphanumeric
    if username.present? && username !~ /^[a-zA-Z0-9]+$/
      errors.add(:username, "can only contain letters and numbers (alphanumeric)")
    end
  end
end
