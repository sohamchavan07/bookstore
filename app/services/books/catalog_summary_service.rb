# frozen_string_literal: true

module Books
  # Builds lightweight metadata for the book catalog so controllers and views
  # stay thin and the summary calculations remain testable.
  class CatalogSummaryService < ApplicationService
    def initialize(scope: Book.all)
      @scope = scope
    end

    def call
      success(
        total_books: @scope.count,
        latest_release_year: @scope.maximum(:published_on)&.year,
        total_categories: Category.count
      )
    end
  end
end
