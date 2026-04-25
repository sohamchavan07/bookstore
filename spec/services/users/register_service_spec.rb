# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegisterService do
  subject(:result) { described_class.call(params) }

  # Suppress the WelcomeEmailJob so DB-level callbacks don't slow tests
  before { allow(WelcomeEmailJob).to receive(:perform_later) }

  context 'with valid params' do
    let(:params) do
      { email: 'new@example.com', password: 'password123', password_confirmation: 'password123' }
    end

    it 'returns a successful result' do
      expect(result.success?).to be true
    end

    it 'returns the persisted user as payload' do
      expect(result.payload).to be_a(User)
      expect(result.payload).to be_persisted
    end

    it 'saves the user with the correct email' do
      expect(result.payload.email).to eq('new@example.com')
    end

    it 'increments the User count' do
      expect { result }.to change(User, :count).by(1)
    end
  end

  context 'with invalid params (blank email)' do
    let(:params) { { email: '', password: 'password123', password_confirmation: 'password123' } }

    it 'returns a failure result' do
      expect(result.failure?).to be true
    end

    it 'populates the error string' do
      expect(result.error).to be_present
    end

    it 'does not create a user' do
      expect { result }.not_to change(User, :count)
    end
  end

  context 'with mismatched passwords' do
    let(:params) do
      { email: 'new@example.com', password: 'password123', password_confirmation: 'wrong' }
    end

    it 'returns a failure result' do
      expect(result.failure?).to be true
    end

    it 'includes a password-related error' do
      expect(result.error).to match(/password/i)
    end
  end
end
