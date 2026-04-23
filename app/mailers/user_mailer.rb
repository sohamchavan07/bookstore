class UserMailer < ApplicationMailer
  def otp_email(user)
    @user = user
    @otp = user.otp_code
    mail(to: @user.email, subject: 'Your One-Time Password (OTP) for Bookstore')
  end
end
