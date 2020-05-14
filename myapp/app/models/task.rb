class Task < ApplicationRecord
  validates :title, presence: true, length: {maximum: 20}

  enum status: { not_start: 0, underway: 10, done: 20}

  scope :search_title, ->(title) {
    title.present? ? where("title like ?", "%#{title}%") : all
  }

  scope :search_status, ->(status) {
    status.present? ? where(status: status) : all
  }

  def self.search(title, status)
    Task.search_title(title).search_status(status)
  end

  def self.human_attribute_enum_val(attr_name, val)
    human_attribute_name("#{attr_name}.#{val}")
  end

  def human_attribute_enum(attr_name)
    self.class.human_attribute_enum_val(attr_name, self[attr_name])
  end
end
