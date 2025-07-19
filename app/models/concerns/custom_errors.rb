module CustomErrors
  extend ActiveSupport::Concern

  class InsufficientFundsError < StandardError; end
  class AccountNotFoundError < StandardError; end
  class TransactionValidationError < StandardError; end
end
