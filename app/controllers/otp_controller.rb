class OtpController < ApplicationController
  def new
  end

  def create
    result = Otp::SendOtpService.call(email: params[:email])

    if result.success?
      session[:otp_email] = result.payload.email
      redirect_to verify_otp_path, notice: 'OTP has been sent to your email.'
    else
      flash.now[:alert] = result.error
      render :new, status: :unprocessable_content
    end
  end

  def verify
    @email = session[:otp_email]
    redirect_to new_otp_path, alert: 'Please request an OTP first.' if @email.nil?
  end

  def validate
    result = Otp::VerifyOtpService.call(email: session[:otp_email], code: params[:otp_code])

    if result.success?
      sign_in(result.payload)
      session.delete(:otp_email)
      redirect_to root_path, notice: 'Logged in successfully via OTP.'
    else
      flash.now[:alert] = result.error
      render :verify, status: :unprocessable_content
    end
  end
end
