class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable,
         :two_factor_authenticatable,
         otp_secret_encryption_key: ENV['OTP_SECRET_ENCRYPTION_KEY'] || Rails.application.credentials.dig(:otp_secret_encryption_key)

  # Configure attr_encrypted for OTP secret
  attr_encrypted :otp_secret,
                 key: [(ENV['OTP_SECRET_ENCRYPTION_KEY'] || Rails.application.credentials.dig(:otp_secret_encryption_key))].pack('H*'),
                 mode: :per_attribute_iv

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

  # Two-Factor Authentication methods
  def enable_two_factor!
    self.otp_required_for_login = true
    self.otp_secret = User.generate_otp_secret
    save!
  end

  def generate_two_factor_secret_if_missing!
    return unless otp_secret.nil?
    update!(otp_secret: User.generate_otp_secret)
  end

  def disable_two_factor!
    self.otp_required_for_login = false
    self.otp_secret = nil
    self.otp_backup_codes = nil
    save!
  end

  def generate_otp_backup_codes!
    codes = 10.times.map { SecureRandom.hex(5) }
    self.otp_backup_codes = codes.to_json
    save!
    codes
  end

  def invalidate_otp_backup_code!(code)
    return false unless otp_backup_codes.present?

    codes = JSON.parse(otp_backup_codes)
    return false unless codes.delete(code)

    self.otp_backup_codes = codes.to_json
    save!
  end
end
