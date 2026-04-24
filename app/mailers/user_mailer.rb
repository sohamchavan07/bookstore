class UserMailer < ApplicationMailer
  def otp_email(user)
    @user = user
    @otp = user.otp_code
    mail(to: @user.email, subject: 'Your One-Time Password (OTP) for Bookstore')
  end

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to our Bookstore!')
  end
end
