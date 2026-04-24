# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user, otp_code: '123456') }

  describe 'otp_email' do
    let(:mail) { UserMailer.otp_email(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Your One-Time Password (OTP) for Bookstore')
      expect(mail.to).to eq([ user.email ])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('123456')
    end
  end

  describe 'welcome_email' do
    let(:mail) { UserMailer.welcome_email(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Welcome to our Bookstore!')
      expect(mail.to).to eq([ user.email ])
    end
  end
end
