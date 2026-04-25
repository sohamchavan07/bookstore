# frozen_string_literal: true

module Users
  # Handles new user registration via Devise.
  #
  # Responsibilities extracted from the Devise RegistrationsController:
  #   - Build the user record from params
  #   - Persist it (Devise callbacks like send_welcome_email fire normally)
  #   - Return a ServiceResult so the controller only handles HTTP concerns
  #
  # Usage:
  #   result = Users::RegisterService.call(user_params)
  #   if result.success?
  #     redirect_to result.payload  # => the persisted User
  #   else
  #     @errors = result.error      # => ActiveModel::Errors or string
  #   end
  class RegisterService < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      user = User.new(@params)

      if user.save
        success(user)
      else
        failure(user.errors.full_messages.join(", "))
      end
    end
  end
end
