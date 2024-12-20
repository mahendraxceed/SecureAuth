class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable

  # Virtual attribute for authenticating by either email or mobile
  attr_accessor :login

  # Validation for mobile_no
  validates :mobile_no, uniqueness: { allow_blank: true },
                        format: { with: /\A\d{10}\z/, message: "must be a valid 10-digit number", allow_blank: true }

  # Override Devise method to find user by either email or mobile
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(email) = :value OR mobile_no = :value", { value: login.downcase }]).first
    elsif conditions.has_key?(:email) || conditions.has_key?(:mobile_no)
      where(conditions.to_h).first
    end
  end

  # Make email optional if mobile is present
  def email_required?
    mobile_no.blank?
  end

  def will_save_change_to_email?
    false
  end
end
