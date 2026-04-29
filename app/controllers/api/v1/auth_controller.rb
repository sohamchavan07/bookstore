module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :verify_authenticity_token, only: [ :login ]
      skip_before_action :authorize_request, only: [ :login ]

      def login
        user = User.find_by(email: params[:email])

        if user&.valid_password?(params[:password])
          token = encode_token({ user_id: user.id })
          render json: { token: token, user: user.as_json(only: [:id, :email, :name]) }
        else
          render json: { error: "Invalid credentials" }, status: :unauthorized
        end
      end
    end
  end
end
