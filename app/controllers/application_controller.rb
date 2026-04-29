# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authorize_request, if: -> { request.format.json? }

  def encode_token(payload)
    JWT.encode(payload, Rails.application.secret_key_base)
  end

  def decode_token(token)
    JWT.decode(token, Rails.application.secret_key_base)[0]
  end

  def authorize_request
    header = request.headers["Authorization"]

    if header.present?
      token = header.split(" ").last
      begin
        decoded = decode_token(token)
        @current_user = User.find(decoded["user_id"])
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    else
      render json: { error: "Missing token" }, status: :unauthorized
    end
  end
end
