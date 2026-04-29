require 'rails_helper'

RSpec.describe 'Api::V1::Auth', type: :request do
  let!(:user) { create(:user, password: 'password123', password_confirmation: 'password123') }

  describe 'POST /api/v1/login' do
    context 'with valid credentials' do
      it 'returns a JWT token' do
        post '/api/v1/login', params: { email: user.email, password: 'password123' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
        expect(JSON.parse(response.body)['user']['email']).to eq(user.email)
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized' do
        post '/api/v1/login', params: { email: user.email, password: 'wrongpassword' }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to have_key('error')
        expect(JSON.parse(response.body)['error']).to eq('Invalid credentials')
      end
    end
  end
end
