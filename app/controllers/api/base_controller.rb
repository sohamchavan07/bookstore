# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActionController::ParameterMissing, with: :parameter_missing

    before_action :authorize_request

    private

    def not_found(exception)
      render json: { error: exception.message }, status: :not_found
    end

    def parameter_missing(exception)
      render json: { error: exception.message }, status: :bad_request
    end

    def current_user
      @current_user
    end
  end
end
