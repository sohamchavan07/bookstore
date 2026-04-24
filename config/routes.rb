# frozen_string_literal: true

require 'socket'

Rails.application.routes.draw do
  root to: 'home#index'
  get 'dashboard', to: 'home#dashboard'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
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
end
