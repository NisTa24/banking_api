class Transaction < ApplicationRecord
  belongs_to :from_account, class_name: "Account", foreign_key: "from_account_id"
  belongs_to :to_account, class_name: "Account", foreign_key: "to_account_id"

  validates :from_account_id, :to_account_id, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :id, presence: true, uuid: true

  validate :accounts_must_be_different
  validate :sufficient_funds_in_source_account

  def amount
    BigDecimal(super.to_s)
  end

  def amount=(value)
    super(BigDecimal(value.to_s))
  end

  # Creates a money transfer between two accounts with full atomicity guarantees.
  #
  # Transaction Flow:
  # 1. Database Transaction Rollback: When any exception is raised inside the
  #    ApplicationRecord.transaction block, the database automatically rolls back
  #    ALL changes made within that transaction, including:
  #    - The Transaction.create! record creation
  #    - Both account balance updates (from_account.update! and to_account.update!)
  #
  # 2. Exception Propagation: After the rollback, the original exception bubbles
  #    up and gets caught by the rescue block.
  #
  # 3. Error Re-raising: The rescue block catches ActiveRecord::RecordInvalid
  #    exceptions and re-raises them as TransactionValidationError with the
  #    original error message.
  #
  # This ensures ATOMICITY - either the entire transfer succeeds (transaction
  # record created AND both account balances updated), or nothing happens at all
  # (complete rollback). There's no possibility of partial state where only some
  # operations succeed.
  def self.create_transfer!(transaction_params)
    amount_decimal = BigDecimal(transaction_params[:amount].to_s)

    ApplicationRecord.transaction do
      account_ids = [ transaction_params[:from_account_id], transaction_params[:to_account_id] ].sort
      locked_accounts = Account.where(id: account_ids).lock.order(:id).to_a

      from_account = locked_accounts.find { |acc| acc.id == transaction_params[:from_account_id] }
      to_account = locked_accounts.find { |acc| acc.id == transaction_params[:to_account_id] }

      raise AccountNotFoundError, "From account not found" unless from_account
      raise AccountNotFoundError, "To account not found" unless to_account

      unless from_account.sufficient_funds?(amount_decimal)
        raise InsufficientFundsError, "Insufficient funds. Available: #{from_account.balance}, Required: #{amount_decimal}"
      end

      transaction = Transaction.create!(transaction_params)

      new_from_balance = from_account.balance - amount_decimal
      new_to_balance = to_account.balance + amount_decimal

      from_account.update!(balance: new_from_balance)
      to_account.update!(balance: new_to_balance)

      transaction
    end
  rescue ActiveRecord::RecordInvalid => e
    raise TransactionValidationError, e.message
  end

  private

  def accounts_must_be_different
    if from_account_id == to_account_id
      errors.add(:to_account_id, "cannot be the same as from_account_id")
    end
  end

  def sufficient_funds_in_source_account
    return unless from_account_id.present? && amount.present?

    from_account = Account.find_by(id: from_account_id)
    if from_account && !from_account.sufficient_funds?(amount)
      errors.add(:amount, "exceeds available balance")
    end
  end
end
