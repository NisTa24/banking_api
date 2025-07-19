class V1::TransactionsController < ApplicationController
  def create
    transaction = Transaction.create_transfer!(transaction_params)
    render json: format_transaction_response(transaction), status: :created
  end

  private

  def transaction_params
    params.require(:transaction).permit(:id, :fromAccountId, :toAccountId, :amount)
                                .transform_keys do |key|
                                  case key
                                  when "fromAccountId" then :from_account_id
                                  when "toAccountId" then :to_account_id
                                  else key.to_sym
                                  end
                                end
  end

  def format_transaction_response(transaction)
    {
      id: transaction.id,
      fromAccountId: transaction.from_account_id,
      toAccountId: transaction.to_account_id,
      amount: transaction.amount.to_f
    }
  end
end
