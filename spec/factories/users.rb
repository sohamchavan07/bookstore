# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    sequence(:supabase_id) { |n| "supabase-#{n}" }
  end
end
