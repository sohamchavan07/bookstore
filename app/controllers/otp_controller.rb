class OtpController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user
      @user.generate_otp!
      OtpMailer.send_otp(@user).deliver_now
      session[:otp_email] = @user.email
      redirect_to verify_otp_path, notice: 'OTP has been sent to your email.'
    else
      flash.now[:alert] = 'Email not found.'
      render :new, status: :unprocessable_content
    end
  end

  def verify
    @email = session[:otp_email]
    redirect_to new_otp_path, alert: 'Please request an OTP first.' if @email.nil?
  end

  def validate
    @email = session[:otp_email]
    @user = User.find_by(email: @email)

    if @user && @user.verify_otp(params[:otp_code])
      sign_in(@user)
      session.delete(:otp_email)
      redirect_to root_path, notice: 'Logged in successfully via OTP.'
    else
      flash.now[:alert] = 'Invalid or expired OTP.'
      render :verify, status: :unprocessable_content
    end
  end
end
