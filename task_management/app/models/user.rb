# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :authority
  has_many :tasks, dependent: :destroy
  has_many :label, dependent: :destroy
end
