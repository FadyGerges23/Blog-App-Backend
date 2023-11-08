class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:login]

  validates :username, presence: true, uniqueness: true
  validate :username_is_alphanumeric

  attr_writer :login

  def login
    @login || username || email
  end

  private

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)

    if login
      where(conditions.to_h).where(["username = :value OR email = :value", { value: login }]).first
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
