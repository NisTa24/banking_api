class ApplicationController < ActionController::API
  rescue_from InsufficientFundsError, with: :insufficient_funds
  rescue_from AccountNotFoundError, with: :account_not_found
  rescue_from TransactionValidationError, with: :transaction_validation_error

  private

  def insufficient_funds(exception)
    render json: { error: exception.message }, status: :bad_request
  end

  def account_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def transaction_validation_error(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end
