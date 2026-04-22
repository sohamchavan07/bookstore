# frozen_string_literal: true

class User < ApplicationRecord
  after_create :send_welcome_email

  private

  def send_welcome_email
    WelcomeEmailJob.perform_later(id)
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
