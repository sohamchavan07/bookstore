require 'sidekiq/web'
require 'socket'

Rails.application.routes.draw do
  redis_available = lambda do |_request|
    Socket.tcp("127.0.0.1", 6379, connect_timeout: 0.2) { |socket| socket.close }
    true
  rescue StandardError
    false
  end

  get "home/index"
  get "dashboard", to: "home#dashboard"
  devise_for :users, sign_out_via: [:delete, :get]
  # Web UI routes
  resources :books
  root to: 'home#index'

  # API routes
  namespace :api do
    namespace :v1 do
      resources :books, only: [:index, :show, :create]
    end
  end

  # Admin/monitoring
  get "/sidekiq", to: "home#sidekiq_unavailable", constraints: ->(request) { !redis_available.call(request) }
  mount Sidekiq::Web => "/sidekiq", constraints: redis_available
end
