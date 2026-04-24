# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WelcomeEmailJob, type: :job do
  let(:user) { create(:user) }

  it 'sends a welcome email' do
    expect {
      WelcomeEmailJob.perform_now(user.id)
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'creates a job log on success' do
    expect {
      WelcomeEmailJob.perform_now(user.id)
    }.to change(JobLog, :count).by(1)

    log = JobLog.last
    expect(log.status).to eq('success')
    expect(log.job_name).to eq('WelcomeEmailJob')
  end

  it 'creates a job log on failure' do
    allow(User).to receive(:find).and_raise(StandardError.new('User not found'))

    expect {
      begin
        WelcomeEmailJob.perform_now(user.id)
      rescue StandardError
        nil
      end
    }.to change(JobLog, :count).by(1)

    log = JobLog.last
    expect(log.status).to eq('failed')
    expect(log.message).to eq('User not found')
  end
end
