class TwoFactorAuthenticationController < ApplicationController

  def enable
    if current_user.otp_required_for_login
      redirect_to root_path, alert: "Two-factor authentication is already enabled."
      return
    end
    current_user.generate_two_factor_secret_if_missing!
    # Generate QR code for authenticator app
    issuer = "SecureAuth"
    label = "#{issuer}:#{current_user.email || current_user.mobile_no}"

    require 'rqrcode'
    @qr_code = RQRCode::QRCode.new(current_user.otp_provisioning_uri(label, issuer: issuer))
    @otp_secret = current_user.otp_secret
  end

  def confirm
    if current_user.validate_and_consume_otp!(params[:otp_code])
      current_user.update!(otp_required_for_login: true)
      backup_codes = current_user.generate_otp_backup_codes!
      flash[:notice] = "Two-factor authentication has been enabled successfully! Save these backup codes in a safe place: #{backup_codes.join(', ')}"
      redirect_to root_path
    else
      flash.now[:alert] = "Invalid verification code. Please try again."
      # Regenerate QR code for re-rendering the enable view
      issuer = "SecureAuth"
      label = "#{issuer}:#{current_user.email || current_user.mobile_no}"
      require 'rqrcode'
      @qr_code = RQRCode::QRCode.new(current_user.otp_provisioning_uri(label, issuer: issuer))
      @otp_secret = current_user.otp_secret
      render :enable
    end
  end

  def disable
    if current_user.valid_password?(params[:password])
      current_user.disable_two_factor!
      redirect_to root_path, notice: "Two-factor authentication has been disabled."
    else
      redirect_to root_path, alert: "Invalid password. Please try again."
    end
  end

  def verify_otp
    if params[:otp_attempt].present?
      if current_user.validate_and_consume_otp!(params[:otp_attempt])
        # OTP is valid, continue with login
        sign_in current_user
        redirect_to root_path, notice: "Signed in successfully."
      else
        flash.now[:alert] = "Invalid authentication code."
        render :otp_form
      end
    end
  end
end
