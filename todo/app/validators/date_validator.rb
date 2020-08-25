# frozen_string_literal: true

class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    Date.iso8601(value.to_s)
  rescue StandardError
    record.errors[attribute] << I18n.t('errors.check_date_at')
  end
end
