# frozen_string_literal: true

module Users
  # Verifies a Supabase JWT and resolves (or creates) the matching local User.
  #
  # Responsibilities extracted from:
  #   - Api::BaseController#authenticate_with_supabase_jwt
  #   - Auth::SessionsController#create
  #
  # Both controllers contained identical JWT-decode + find-or-create logic.
  # Centralising it here means a single place to change if the algorithm or
  # secret rotation strategy changes.
  #
  # Usage:
  #   result = Users::AuthenticateWithSupabaseJwtService.call(token)
  #   if result.success?
  #     @current_user = result.payload  # => User instance
  #   else
  #     render json: { error: result.error }, status: :unauthorized
  #   end
  class AuthenticateWithSupabaseJwtService < ApplicationService
    def initialize(token)
      @token = token
    end

    def call
      return failure("Authorization token missing") if @token.blank?

      decoded_token = JWT.decode(@token, Supabase.jwt_secret, true, { algorithm: "HS256" })
      payload = decoded_token.first

      user = find_or_create_user(payload)
      success(user)
    rescue JWT::DecodeError => e
      failure("Invalid token: #{e.message}")
    rescue ActiveRecord::RecordInvalid => e
      failure(e.message)
    end

    private

    def find_or_create_user(payload)
      supabase_id = payload["sub"]
      email       = payload["email"]

      user = User.find_or_create_by!(supabase_id: supabase_id) do |u|
        u.email    = email
        u.password = Devise.friendly_token[0, 20]
      end

      # Backfill supabase_id for users created via email/password before OAuth
      user.update!(supabase_id: supabase_id) if user.supabase_id.blank?
      user
    end
  end
end
