# frozen_string_literal: true

# Base class for all Service Objects in the Bookstore application.
#
# Conventions:
#   - Subclasses implement a public #call method containing the business logic.
#   - Use the class-level .call shortcut so callers never need to call .new.
#   - Return a ServiceResult value object so controllers can branch on success/failure
#     without relying on exceptions for flow control.
#
# Usage:
#   result = MyService.call(param: value)
#   result.success? # => true / false
#   result.payload  # => the returned value on success
#   result.error    # => an error message string on failure
class ApplicationService
  # Lightweight value object returned by every service.
  Result = Struct.new(:success?, :payload, :error, keyword_init: true) do
    def failure? = !success?
  end

  # Class-level shortcut: MyService.call(...) == MyService.new(...).call
  def self.call(...)
    new(...).call
  end

  private

  # Helpers for building results inside subclass #call methods.

  def success(payload = nil)
    Result.new(success?: true, payload: payload, error: nil)
  end

  def failure(error)
    Result.new(success?: false, payload: nil, error: error)
  end
end
