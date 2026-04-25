# frozen_string_literal: true

module Otp
  # Verifies a submitted OTP code for a given email address.
  #
  # Responsibilities extracted from OtpController#validate:
  #   - Look up the user by email stored in session
  #   - Delegate to User#verify_otp which checks code match + expiry
  #
  # Usage:
  #   result = Otp::VerifyOtpService.call(email: session[:otp_email], code: params[:otp_code])
  #   if result.success?
  #     sign_in result.payload
  #     session.delete(:otp_email)
  #     redirect_to root_path
  #   else
  #     flash.now[:alert] = result.error
  #     render :verify
  #   end
  class VerifyOtpService < ApplicationService
    def initialize(email:, code:)
      @email = email
      @code  = code
    end

    def call
      user = User.find_by(email: @email)
      return failure("Invalid or expired OTP.") unless user&.verify_otp(@code)

      success(user)
    end
  end
end
