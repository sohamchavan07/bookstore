# frozen_string_literal: true

module Api
  module V1
    class BooksController < Api::BaseController
      # GET /api/v1/books
      def index
        result = Books::SearchBooksService.call(query: params[:query], category_id: params[:category_id])
        render json: BookSerializer.new(result.payload).serializable_hash
      end

      # GET /api/v1/books/:id
      def show
        book = Book.find(params[:id])
        render json: BookSerializer.new(book).serializable_hash
      end

      # POST /api/v1/books
      def create
        result = Books::CreateBookService.call(book_params)

        if result.success?
          render json: BookSerializer.new(result.payload).serializable_hash, status: :created
        else
          render json: { errors: result.error }, status: :unprocessable_entity
        end
      end

      private

      def book_params
        params.require(:book).permit(:title, :author, :price, :category_id, :published_on)
      end
    end
  end
end
