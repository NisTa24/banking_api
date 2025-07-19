# Ensure BigDecimal precision is consistent across the application
BigDecimal.mode(BigDecimal::ROUND_HALF_UP)

# Set default precision for monetary calculations
module MoneyPrecision
  PRECISION = 15
  SCALE = 2

  def self.normalize(value)
    BigDecimal(value.to_s).round(SCALE)
  end
end
