# frozen_string_literal: true

class UserProject < ApplicationRecord
  has_many :project
end
