# frozen_string_literal: true

module Books
  # Searches and filters the books catalogue.
  #
  # Responsibilities extracted from BooksController#index:
  #   - Start from the full catalogue
  #   - Apply full-text search when a query param is present
  #   - Apply category filter when a category_id param is present
  #
  # Keeping the query-building logic here means:
  #   - The controller stays a thin router
  #   - The same filtering can be reused by the API controller without copy-pasting
  #   - Filtering rules are trivially unit-testable
  #
  # Usage:
  #   result = Books::SearchBooksService.call(query: params[:query], category_id: params[:category_id])
  #   @books = result.payload   # => ActiveRecord::Relation
  class SearchBooksService < ApplicationService
    def initialize(query: nil, category_id: nil)
      @query       = query
      @category_id = category_id
    end

    def call
      books = Book.all
      books = books.search_by_term(@query)       if @query.present?
      books = books.by_category(@category_id)    if @category_id.present?

      success(books)
    end
  end
end
