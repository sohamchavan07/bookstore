# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::AuthenticateWithSupabaseJwtService do
  subject(:result) { described_class.call(token) }

  before { allow(WelcomeEmailJob).to receive(:perform_later) }

  # Helper: build a signed HS256 JWT that looks like one from Supabase
  def build_token(sub:, email:, secret: Supabase.jwt_secret)
    payload = { 'sub' => sub, 'email' => email, 'exp' => 1.hour.from_now.to_i }
    JWT.encode(payload, secret, 'HS256')
  end

  context 'when the token is valid and user does not yet exist' do
    let(:token) { build_token(sub: 'supa-abc', email: 'fresh@example.com') }

    it 'returns a successful result' do
      expect(result.success?).to be true
    end

    it 'creates a new local user' do
      expect { result }.to change(User, :count).by(1)
    end

    it 'returns the user as payload' do
      expect(result.payload).to be_a(User)
      expect(result.payload.email).to eq('fresh@example.com')
      expect(result.payload.supabase_id).to eq('supa-abc')
    end
  end

  context 'when the token is valid and user already exists' do
    let!(:user) { create(:user, supabase_id: 'supa-xyz', email: 'known@example.com') }
    let(:token) { build_token(sub: 'supa-xyz', email: 'known@example.com') }

    it 'returns a successful result' do
      expect(result.success?).to be true
    end

    it 'does not create a duplicate user' do
      expect { result }.not_to change(User, :count)
    end

    it 'returns the existing user' do
      expect(result.payload).to eq(user)
    end
  end

  context 'when the token is signed with the wrong secret' do
    let(:token) { build_token(sub: 'supa-bad', email: 'hacker@example.com', secret: 'wrong-secret') }

    it 'returns a failure result' do
      expect(result.failure?).to be true
    end

    it 'returns a meaningful error message' do
      expect(result.error).to match(/invalid token/i)
    end
  end

  context 'when the token is blank' do
    let(:token) { nil }

    it 'returns a failure result' do
      expect(result.failure?).to be true
    end

    it 'returns a missing-token error message' do
      expect(result.error).to eq('Authorization token missing')
    end
  end

  context 'when the token is malformed' do
    let(:token) { 'not.a.real.token' }

    it 'returns a failure result' do
      expect(result.failure?).to be true
    end

    it 'returns an error message mentioning the token' do
      expect(result.error).to match(/invalid token/i)
    end
  end
end
