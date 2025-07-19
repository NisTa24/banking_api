class UuidValidator < ActiveModel::EachValidator
  UUID_REGEX = /\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i

  def validate_each(record, attribute, value)
    unless value =~ UUID_REGEX
      record.errors.add(attribute, options[:message] || "must be a valid UUID")
    end
  end
end
