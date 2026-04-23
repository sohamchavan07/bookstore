# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]
  before_action :set_categories, only: %i[new edit create update]
  before_action :authenticate_user!, except: %i[index show]

  # GET /books
  def index
    @books = Book.all
    @books = @books.search_by_term(params[:query]) if params[:query].present?
    @books = @books.by_category(params[:category_id]) if params[:category_id].present?

    @categories = Category.order(:name)
  end

  # GET /books/1
  def show; end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit; end

  # POST /books
  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book, notice: 'Book was successfully created.'
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /books/1
  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'Book was successfully updated.'
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /books/1
  def destroy
    @book.destroy
    redirect_to books_url, notice: 'Book was successfully destroyed.'
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :price, :published_on, :category_id)
  end

  def set_categories
    @categories = Category.order(:name)
  end
end
