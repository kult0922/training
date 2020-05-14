class Task < ApplicationRecord
  validates :title, presence: true, length: {maximum: 20}

  enum status: { not_start: 0, underway: 10, done: 20}

  def self.human_attribute_enum_val(attr_name, val)
    human_attribute_name("#{attr_name}.#{val}")
  end

  def human_attribute_enum(attr_name)
    self.class.human_attribute_enum_val(attr_name, self[attr_name])
  end
end
