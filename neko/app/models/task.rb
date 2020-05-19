class Task < ApplicationRecord
  validates :name, presence: true
  belongs_to :status
  belongs_to :user

  def self.search(search, current_user)
    if search[:name].blank? && search[:status].nil?
      Task.with_relevant(current_user)
    elsif search[:status].nil?
      Task.with_relevant(current_user).where(['name LIKE ?', "%#{search[:name]}%"])
    elsif search[:name].blank?
      Task.with_relevant(current_user).where(status_id: search[:status])
    else
      Task.with_relevant(current_user).where(status_id: search[:status]).where(['name LIKE ?', "%#{search[:name]}%"])
    end
  end

  def self.with_relevant(current_user)
    Task.includes(:status).includes(:user).where(user_id: current_user)
  end
end
