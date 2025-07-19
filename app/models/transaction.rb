class Transaction < ApplicationRecord
  belongs_to :from_account, class_name: "Account", foreign_key: "from_account_id"
  belongs_to :to_account, class_name: "Account", foreign_key: "to_account_id"

  validates :from_account_id, :to_account_id, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :accounts_must_be_different
  validate :sufficient_funds_in_source_account

  def amount
    BigDecimal(super.to_s)
  end

  def amount=(value)
    super(BigDecimal(value.to_s))
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
