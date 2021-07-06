class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, I18n.t('errors.messages.invalid_date_format') unless /\A\d{1,4}-\d{1,2}-\d{1,2}\Z/ =~ value.to_s
    begin
      (y, m, d) = value.to_s.split('-')
      Time.zone.local(y, m, d, 0, 0, 0)
    rescue StandardError
      record.errors.add attribute, I18n.t('errors.messages.invalid_date')
    end
  end
end
