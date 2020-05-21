class TaskSearchParam
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :status, :string

  validates :title, length: {maximum: 20}  

end
