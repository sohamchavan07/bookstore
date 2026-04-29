# frozen_string_literal: true

module AuthHelper
  def authenticated_header(user)
    payload = { user_id: user.id }
    token = JWT.encode(payload, Rails.application.secret_key_base)
    { 'Authorization' => "Bearer #{token}" }
  end
end
