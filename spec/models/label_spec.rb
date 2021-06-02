# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  let(:user) { FactoryBot.create(:user) }
  it '名前とユーザが設定されていれば有効' do
    label = Label.new(name: 'label', user: user)
    expect(label).to be_valid
  end

  it '名前が設定されていなければ無効' do
    label = Label.new(user: user)
    label.valid?
    expect(label.errors[:name]).to include('入力がありません')
  end

  it '同じユーザーでラベルの名前が重複している場合は無効' do
    Label.create(name: 'abc', user: user)
    label = Label.new(name: 'abc', user: user)
    label.valid?
    expect(label.errors[:name]).to include('同じ名前のラベルがあります')
  end

  it '異なるユーザーでラベルの名前が重複している場合は有効' do
    Label.create(name: 'abc', user: user)
    label = Label.new(name: 'abc', user: FactoryBot.create(:user))
    expect(label).to be_valid
  end
end
