# frozen_string_literal: true

module Books
  # Creates a new Book record.
  #
  # Responsibilities extracted from BooksController#create and Api::V1::BooksController#create:
  #   - Build the Book from permitted params
  #   - Persist it
  #   - Return a structured result so both the HTML and JSON controllers
  #     can share the same creation logic without duplication.
  #
  # Usage:
  #   result = Books::CreateBookService.call(book_params)
  #   if result.success?
  #     redirect_to result.payload   # HTML controller
  #     # or
  #     render json: BookSerializer.new(result.payload).serializable_hash, status: :created
  #   else
  #     @book = result.payload       # re-populate form / return errors
  #   end
  class CreateBookService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      book = Book.new(@params)

      if book.save
        success(book)
      else
        failure(book.errors.full_messages.join(", "))
      end
    end
  end
end
