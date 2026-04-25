# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!, only: [ :dashboard ]
  def index
    @featured_books = Book.includes(:category).order(created_at: :desc).limit(6)
    @categories = Category.all.limit(4)
  end

  def dashboard
    @book_count = Book.count
    @latest_books = Book.order(created_at: :desc).limit(5)
  end

  def sidekiq_unavailable
    render plain: 'Sidekiq Web is unavailable because Redis is not running on localhost:6379. Start Redis and refresh this page.',
           status: :service_unavailable
  end
end
