# frozen_string_literal: true

require 'socket'

Rails.application.routes.draw do
  get 'home/index'
  get 'dashboard', to: 'home#dashboard'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, sign_out_via: %i[delete get]
  # Web UI routes
  resources :books
  root to: 'home#index'

  # API routes
  namespace :api do
    namespace :v1 do
      resources :books, only: %i[index show create]
    end
  end
end
