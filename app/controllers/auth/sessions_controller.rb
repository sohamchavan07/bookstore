module Auth
  class SessionsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [ :create ], if: -> { request.format.json? }

    def new
    end

    def create
      token = params[:access_token]
      return render json: { error: 'No token provided' }, status: :bad_request if token.blank?

      begin
        # Verify the token with Supabase JWT Secret
        # Note: In a real app, you'd want to handle multiple keys or fetch from JWKS if available
        # But for Supabase, it's a fixed secret.
        decoded_token = JWT.decode(token, Supabase.jwt_secret, true, { algorithm: 'HS256' })
        payload = decoded_token.first

        supabase_id = payload['sub']
        email = payload['email']

        user = User.find_or_create_by!(email: email) do |u|
          u.supabase_id = supabase_id
          u.password = SecureRandom.hex(16) if u.respond_to?(:password=) # For Devise compatibility
        end

        user.update!(supabase_id: supabase_id) if user.supabase_id.blank?

        session[:user_id] = user.id
        render json: { message: 'Logged in successfully' }, status: :ok
      rescue JWT::DecodeError => e
        render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_path, notice: 'Logged out successfully'
    end
  end
end
