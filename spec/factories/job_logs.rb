# frozen_string_literal: true

FactoryBot.define do
  factory :job_log do
    job_name { 'MyString' }
    status { 'MyString' }
    executed_at { '2025-08-30 00:31:51' }
    message { 'MyText' }
  end
end
