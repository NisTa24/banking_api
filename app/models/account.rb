class Account < ApplicationRecord
  has_many :outgoing_transactions,
           class_name: "Transaction",
           foreign_key_id: "from_account_id",
           dependent: :restrict_with_exception

  has_many :incoming_transactions,
           class_name: "Transaction",
           foreign_key_id: "to_account_id",
           dependent: :restrict_with_exception

  def balance
    BigDecimal(super.to_s)
  end

  def balance=(value)
    super(BigDecimal(value.to_s))
  end

  def sufficient_funds?(amount)
    balance >= BigDecimal(amount.to_s)
  end
end
