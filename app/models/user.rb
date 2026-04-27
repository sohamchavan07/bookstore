# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  after_commit :send_welcome_email, on: :create

  def generate_otp!
    self.otp_code = sprintf('%06d', rand(100_000..999_999))
    self.otp_sent_at = Time.current
    save!
  end

  def verify_otp(code)
    return false if otp_code.nil? || otp_sent_at < 10.minutes.ago

    if otp_code == code
      update!(otp_code: nil, otp_sent_at: nil)
      true
    else
      false
    end
  end

  private

  def send_welcome_email
    WelcomeEmailJob.perform_later(id)
  rescue StandardError => e
    Rails.logger.error("Welcome email enqueue failed for user #{id}: #{e.class} - #{e.message}")
  end
end
