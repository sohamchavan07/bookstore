# frozen_string_literal: true

class BookSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :author, :price, :category_id, :created_at, :updated_at
end
