# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { 'Sample Book' }
    author { 'Author Name' }
    price { 100 }
    association :category # assumes Book belongs_to :category
  end
end
