class Account < ApplicationRecord
  has_many :outgoing_transactions,
           class_name: "Transaction",
           foreign_key: "from_account_id",
           dependent: :restrict_with_exception

  has_many :incoming_transactions,
           class_name: "Transaction",
           foreign_key: "to_account_id",
           dependent: :restrict_with_exception

  def balance
    BigDecimal(super.to_s)
  end

  def balance=(value)
    super(BigDecimal(value.to_s))
  end

  def update_balance!(new_balance)
    Account.transaction do
      account = Account.lock.find(id)

      if new_balance < 0
        raise InsufficientFundsError, "Insufficient funds. Current balance: #{account.balance}, attempted: #{new_balance}"
      end

      account.update!(balance: new_balance)
      account.balance
    end
  end

  def sufficient_funds?(amount)
    balance >= BigDecimal(amount.to_s)
  end
end
