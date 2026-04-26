# frozen_string_literal: true

require 'socket'
require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'home#index'
  get 'dashboard', to: 'home#dashboard'
  devise_for :users, path: '', controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  get 'otp/test_setup', to: 'otp#test_setup'

  # OTP routes
  get 'otp/new', to: 'otp#new', as: :new_otp
  post 'otp/create', to: 'otp#create', as: :create_otp
  get 'otp/verify', to: 'otp#verify', as: :verify_otp
  post 'otp/validate', to: 'otp#validate', as: :validate_otp
  resources :books

  # API routes
  namespace :api do
    namespace :v1 do
      resources :books, only: %i[index show create]
    end
  end

  # Sidekiq Web UI (development only)
  if Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
  end

  # Favicon redirect
  get '/favicon.ico', to: redirect('/favicon.png')

  # Custom Error Pages
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
