# frozen_string_literal: true

class Book < ApplicationRecord
  # Validations
  validates :title,  presence: true
  validates :author, presence: true
  validates :price,  numericality: { greater_than: 0 }

  belongs_to :category

  # Custom method: "Title by Author (₹Price)"
  def formatted_details
    "#{title} by #{author} (₹#{format('%.2f', price)})"
  end
end
