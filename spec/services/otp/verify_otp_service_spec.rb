# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Otp::VerifyOtpService do
  subject(:result) { described_class.call(email: email, code: code) }

  let!(:user) { create(:user) }

  before do
    user.update!(otp_code: '123456', otp_sent_at: Time.current)
  end

  context 'with a valid, unexpired OTP' do
    let(:email) { user.email }
    let(:code)  { '123456' }

    it 'returns a successful result' do
      expect(result.success?).to be true
    end

    it 'returns the authenticated user as payload' do
      expect(result.payload).to eq(user)
    end

    it 'clears the OTP from the user record after verification' do
      result
      expect(user.reload.otp_code).to be_nil
      expect(user.reload.otp_sent_at).to be_nil
    end
  end

  context 'with a wrong OTP code' do
    let(:email) { user.email }
    let(:code)  { '000000' }

    it 'returns a failure result' do
      expect(result.failure?).to be true
    end

    it 'returns an appropriate error message' do
      expect(result.error).to eq('Invalid or expired OTP.')
    end

    it 'does not clear the OTP' do
      result
      expect(user.reload.otp_code).to eq('123456')
    end
  end

  context 'with an expired OTP (sent more than 10 minutes ago)' do
    let(:email) { user.email }
    let(:code)  { '123456' }

    before { user.update!(otp_sent_at: 11.minutes.ago) }

    it 'returns a failure result' do
      expect(result.failure?).to be true
    end

    it 'returns an appropriate error message' do
      expect(result.error).to eq('Invalid or expired OTP.')
    end
  end

  context 'when no user exists with that email' do
    let(:email) { 'ghost@example.com' }
    let(:code)  { '123456' }

    it 'returns a failure result' do
      expect(result.failure?).to be true
    end

    it 'returns an appropriate error message' do
      expect(result.error).to eq('Invalid or expired OTP.')
    end
  end
end
