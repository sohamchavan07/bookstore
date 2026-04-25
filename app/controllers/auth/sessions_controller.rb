module Auth
  class SessionsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [ :create ], if: -> { request.format.json? }

    def new
    end

    def create
      token  = params[:access_token]
      result = Users::AuthenticateWithSupabaseJwtService.call(token)

      if result.success?
        session[:user_id] = result.payload.id
        render json: { message: 'Logged in successfully' }, status: :ok
      else
        status = token.blank? ? :bad_request : :unauthorized
        render json: { error: result.error }, status: status
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_path, notice: 'Logged out successfully'
    end
  end
end
