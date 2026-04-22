# frozen_string_literal: true

class WelcomeEmailJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    UserMailer.welcome_email(user).deliver_now
    create_job_log(status: 'success', message: "Welcome email sent to #{user.email}")
  rescue StandardError => e
    create_job_log(status: 'failed', message: e.message)
    raise e
  end

  private

  def create_job_log(status:, message:)
    JobLog.create!(
      job_name: self.class.name,
      status: status,
      executed_at: Time.current,
      message: message
    )
  end
end
