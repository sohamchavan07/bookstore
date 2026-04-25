# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Otp::SendOtpService do
  subject(:result) { described_class.call(email: email) }

  context 'when the email belongs to an existing user' do
    let!(:user) { create(:user) }
    let(:email) { user.email }

    before do
      # Stub the mailer so no real email is sent during tests
      mailer_double = instance_double(ActionMailer::MessageDelivery, deliver_now: true)
      allow(OtpMailer).to receive(:send_otp).and_return(mailer_double)
    end

    it 'returns a successful result' do
      expect(result.success?).to be true
    end

    it 'returns the user as payload' do
      expect(result.payload).to eq(user)
    end

    it 'generates an OTP on the user record' do
      result
      expect(user.reload.otp_code).to be_present
    end

    it 'sets otp_sent_at to around now' do
      result
      expect(user.reload.otp_sent_at).to be_within(5.seconds).of(Time.current)
    end

    it 'calls the OtpMailer' do
      expect(OtpMailer).to receive(:send_otp).with(user)
      result
    end
  end

  context 'when no user exists with that email' do
    let(:email) { 'nobody@example.com' }

    it 'returns a failure result' do
      expect(result.failure?).to be true
    end

    it 'returns an appropriate error message' do
      expect(result.error).to eq('Email not found.')
    end

    it 'does not call the mailer' do
      expect(OtpMailer).not_to receive(:send_otp)
      result
    end
  end
end
