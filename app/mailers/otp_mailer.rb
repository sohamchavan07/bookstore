class OtpMailer < ApplicationMailer
  def send_otp(user)
    @user = user
    @otp = user.otp_code
    mail(to: @user.email, subject: 'Your OTP for Bookstore Login')
  end
end
