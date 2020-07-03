class TaskSearchParam
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :status, :string
  attribute :label_ids

  validates :title, length: { maximum: 20 }
end
