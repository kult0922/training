class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value = record.send("#{attribute}_before_type_cast")
    begin
      Date.parse value if value.present? && value.kind_of?(String)
    rescue ArgumentError
      record.errors[attribute] << "Invalid date format."
    end
  end
end
