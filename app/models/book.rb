# frozen_string_literal: true

class Book < ApplicationRecord
  # Validations
  validates :title,  presence: true
  validates :author, presence: true
  validates :price,  numericality: { greater_than: 0 }

  belongs_to :category

  # Scopes for Search and Filter
  scope :search_by_term, ->(term) {
    where("title ILIKE :term OR author ILIKE :term", term: "%#{term}%")
  }
  scope :by_category, ->(category_id) {
    where(category_id: category_id)
  }

  # Custom method: "Title by Author (₹Price)"
  def formatted_details
    "#{title} by #{author} (₹#{format('%.2f', price)})"
  end
end
