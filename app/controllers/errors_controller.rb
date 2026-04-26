class ErrorsController < ApplicationController
  def not_found
    skip_authorization if respond_to?(:skip_authorization)
    render status: :not_found
  end

  def internal_server_error
    skip_authorization if respond_to?(:skip_authorization)
    render status: :internal_server_error
  end
end
