# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  after_create :send_welcome_email

  def self.from_omniauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid) || find_by(email: auth.info.email)

    if user
      user.update(provider: auth.provider, uid: auth.uid) if user.provider.blank?
    else
      user = create!(
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        password: Devise.friendly_token[0, 20]
      )
    end
    user
  end

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
  end
end
