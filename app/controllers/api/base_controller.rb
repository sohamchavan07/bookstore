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
      token  = request.headers["Authorization"]&.split(" ")&.last
      result = Users::AuthenticateWithSupabaseJwtService.call(token)

      if result.success?
        @current_user = result.payload
      else
        render json: { error: result.error }, status: :unauthorized
      end
    end

    def current_user
      @current_user
    end
  end
end
