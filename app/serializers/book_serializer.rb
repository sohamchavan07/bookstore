# frozen_string_literal: true

class BookSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :author, :price, :category_id, :published_on, :created_at, :updated_at
end
