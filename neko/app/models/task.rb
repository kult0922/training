class Task < ApplicationRecord
  validates :name, presence: true
  belongs_to :status
  belongs_to :user

  def self.search(search)
    if search[:name].blank? && search[:status].nil?
      Task.with_relevant.all
    elsif search[:status].nil?
      Task.with_relevant.where(['name LIKE ?', "%#{search[:name]}%"])
    elsif search[:name].blank?
      Task.with_relevant.where(status_id: search[:status])
    else
      Task.with_relevant.where(status_id: search[:status]).where(['name LIKE ?', "%#{search[:name]}%"])
    end
  end

  def self.with_relevant
    Task.includes(:status).includes(:user)
  end
end
