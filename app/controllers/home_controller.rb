class HomeController < ApplicationController
  def index
  end

  def dashboard
    @book_count = Book.count
    @latest_books = Book.order(created_at: :desc).limit(5)
  end

  def sidekiq_unavailable
    render plain: "Sidekiq Web is unavailable because Redis is not running on localhost:6379. Start Redis and refresh this page.", status: :service_unavailable
  end
end
