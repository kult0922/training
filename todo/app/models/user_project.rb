# frozen_string_literal: true

class UserProject < ApplicationRecord
  has_many :projects
end
