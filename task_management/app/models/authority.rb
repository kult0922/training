# frozen_string_literal: true

# 権限マスタ
class Authority < ApplicationRecord
  has_many :users, dependent: :destroy
end
