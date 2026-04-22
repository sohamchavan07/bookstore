# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Our App!')
  end
end
