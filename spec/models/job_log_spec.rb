# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobLog, type: :model do
  it 'is valid with valid attributes' do
    job_log = JobLog.new(
      job_name: 'TestJob',
      status: 'success',
      executed_at: Time.current,
      message: 'Test message'
    )
    expect(job_log).to be_valid
  end
end
