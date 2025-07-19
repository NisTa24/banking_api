class V1::AccountsController < ApplicationController
  def create
    account = Account.new(account_params)

    if account.save
      render json: format_account_response(account), status: :created
    else
      render json: { error: account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    account = Account.find(params[:account_id])
    render json: format_account_response(account), status: :ok
  end

  private

  def account_params
    params.permit(:id, :balance)
  end

  def format_account_response(account)
    {
      id: account.id,
      balance: account.balance.to_f
    }
  end
end
