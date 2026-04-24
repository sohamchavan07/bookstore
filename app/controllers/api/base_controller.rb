# frozen_string_literal: true

module Api
  class BaseController < ActionController::API
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActionController::ParameterMissing, with: :parameter_missing

    before_action :authenticate_with_supabase_jwt

    private

    def not_found(exception)
      render json: { error: exception.message }, status: :not_found
    end

    def parameter_missing(exception)
      render json: { error: exception.message }, status: :bad_request
    end

    def authenticate_with_supabase_jwt
      auth_header = request.headers['Authorization']
      token = auth_header&.split(' ')&.last

      if token
        begin
          # Decode the token using the Supabase JWT secret
          decoded_token = JWT.decode(token, Supabase.jwt_secret, true, { algorithm: 'HS256' })
          payload = decoded_token.first

          # Find or create user based on the 'sub' (Supabase ID)
          @current_user = User.find_or_create_by(supabase_id: payload['sub']) do |user|
            user.email = payload['email']
            user.password = Devise.friendly_token[0, 20]
          end
        rescue JWT::DecodeError => e
          render json: { error: 'Invalid token', detail: e.message }, status: :unauthorized
        end
      else
        render json: { error: 'Authorization token missing' }, status: :unauthorized
      end
    end

    def current_user
      @current_user
    end
  end
end
