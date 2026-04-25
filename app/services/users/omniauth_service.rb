# frozen_string_literal: true

module Users
  # Handles Google OAuth2 sign-in / sign-up via OmniAuth.
  #
  # Responsibilities extracted from User.from_omniauth (model method):
  #   - Look up an existing user by provider+uid or email
  #   - Backfill missing provider/uid on legacy email-only accounts
  #   - Create a brand-new user when no match is found
  #
  # Keeping this logic here (instead of on the model) makes it:
  #   - Easy to unit-test without touching the HTTP layer
  #   - Easy to extend (e.g. log the event, fire an analytics call)
  #
  # Usage:
  #   result = Users::OmniauthService.call(auth)
  #   if result.success?
  #     sign_in_and_redirect result.payload
  #   else
  #     redirect_to new_user_registration_url, alert: result.error
  #   end
  class OmniauthService < ApplicationService
    def initialize(auth)
      @auth = auth
    end

    def call
      user = find_existing_user || build_new_user
      return failure(user.errors.full_messages.join(", ")) unless user.persisted?

      success(user)
    rescue ActiveRecord::RecordInvalid => e
      failure(e.message)
    end

    private

    def find_existing_user
      user = User.find_by(provider: @auth.provider, uid: @auth.uid) ||
             User.find_by(email: @auth.info.email)

      if user && user.provider.blank?
        user.update(provider: @auth.provider, uid: @auth.uid)
      end

      user
    end

    def build_new_user
      User.create!(
        provider: @auth.provider,
        uid: @auth.uid,
        email: @auth.info.email,
        password: Devise.friendly_token[0, 20]
      )
    end
  end
end
