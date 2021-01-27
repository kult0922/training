# frozen_string_literal: true

class Role < ApplicationRecord
  has_many :users, dependent: :destroy

  def translated_name
    I18n.t(name, scope: 'roles')
  end
end
