# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthService do
  # Builds a minimal OmniAuth auth hash that mirrors Google's shape
  def build_auth(uid:, email:, provider: 'google_oauth2')
    OmniAuth::AuthHash.new(
      provider: provider,
      uid: uid,
      info: OmniAuth::AuthHash::InfoHash.new(email: email)
    )
  end

  before { allow(WelcomeEmailJob).to receive(:perform_later) }

  subject(:result) { described_class.call(auth) }

  context 'when the user is brand new' do
    let(:auth) { build_auth(uid: 'google-111', email: 'neo@example.com') }

    it 'returns a successful result' do
      expect(result.success?).to be true
    end

    it 'creates a new user' do
      expect { result }.to change(User, :count).by(1)
    end

    it 'sets provider and uid on the new user' do
      expect(result.payload.provider).to eq('google_oauth2')
      expect(result.payload.uid).to eq('google-111')
      expect(result.payload.email).to eq('neo@example.com')
    end
  end

  context 'when a user already exists with matching provider + uid' do
    let!(:user) { create(:user, provider: 'google_oauth2', uid: 'google-222', email: 'existing@example.com') }
    let(:auth)  { build_auth(uid: 'google-222', email: 'existing@example.com') }

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

  context 'when a user exists by email but has no provider (legacy account)' do
    let!(:user) { create(:user, provider: nil, uid: nil, email: 'legacy@example.com') }
    let(:auth)  { build_auth(uid: 'google-333', email: 'legacy@example.com') }

    it 'returns a successful result' do
      expect(result.success?).to be true
    end

    it 'backfills provider and uid on the existing user' do
      result
      expect(user.reload.provider).to eq('google_oauth2')
      expect(user.reload.uid).to eq('google-333')
    end

    it 'does not create a new user' do
      expect { result }.not_to change(User, :count)
    end
  end
end
