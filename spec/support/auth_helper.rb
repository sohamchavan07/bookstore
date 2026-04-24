# frozen_string_literal: true

module AuthHelper
  def authenticated_header(user)
    payload = {
      'sub' => user.supabase_id,
      'email' => user.email,
      'exp' => (Time.now + 1.hour).to_i
    }
    
    # Mock Supabase.jwt_secret to ensure consistency
    allow(Supabase).to receive(:jwt_secret).and_return('test_secret')
    
    token = JWT.encode(payload, 'test_secret', 'HS256')
    { 'Authorization' => "Bearer #{token}" }
  end
end
