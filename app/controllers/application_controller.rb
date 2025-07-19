class ApplicationController < ActionController::API
  rescue_from InsufficientFundsError, with: :insufficient_funds

  private

  def insufficient_funds(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end
