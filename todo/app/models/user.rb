# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_project, dependent: :delete_all
  has_many :task, dependent: :nullify
end
