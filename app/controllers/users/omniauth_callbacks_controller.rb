# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth_payload = request.env['omniauth.auth']
    return handle_oauth_failure('Google authentication failed. Please try again.') if auth_payload.blank?

    result = Users::OmniauthService.call(auth_payload)

    if result.success?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect result.payload, event: :authentication
    else
      session['devise.google_data'] = {
        provider: auth_payload.provider,
        uid: auth_payload.uid,
        email: auth_payload.dig('info', 'email') || auth_payload.info&.email
      }.compact
      redirect_to new_user_registration_url, alert: result.error
    end
  rescue StandardError => e
    Rails.logger.error("Google OAuth callback error: #{e.class} - #{e.message}")
    Rails.logger.error(e.backtrace.first(10).join("\n")) if e.backtrace.present?
    handle_oauth_failure('Unable to sign in with Google right now. Please try again.')
  end

  def failure
    oauth_error = request.env['omniauth.error']&.message || params[:message]
    handle_oauth_failure(oauth_error.presence || 'Google authentication was cancelled or failed.')
  end

  private

  def handle_oauth_failure(message)
    redirect_to new_user_session_path, alert: message
  end
end
