# frozen_string_literal: true

module Otp
  # Generates a fresh OTP for a user and delivers it via email.
  #
  # Responsibilities extracted from OtpController#create:
  #   - Look up the user by email
  #   - Call generate_otp! to set the code + timestamp
  #   - Send the OTP mailer
  #
  # Usage:
  #   result = Otp::SendOtpService.call(email: "user@example.com")
  #   if result.success?
  #     session[:otp_email] = result.payload.email
  #     redirect_to verify_otp_path
  #   else
  #     flash.now[:alert] = result.error
  #     render :new
  #   end
  class SendOtpService < ApplicationService
    def initialize(email:)
      @email = email
    end

    def call
      user = User.find_by(email: @email)
      return failure("Email not found.") if user.nil?

      user.generate_otp!
      OtpMailer.send_otp(user).deliver_now

      success(user)
    rescue ActiveRecord::RecordInvalid => e
      failure(e.message)
    end
  end
end
