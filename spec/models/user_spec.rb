# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it '名前・メールアドレス・パスワードが設定されていれば有効' do
    user = User.new(name: 'user', email: 'abc@xxx.com', password: 'xxxxxxxx', password_confirmation: 'xxxxxxxx')
    expect(user).to be_valid
  end

  it '名前が設定されていなければ無効' do
    user = User.new(email: 'abc@xxx.com', password: 'xxxxxxxx', password_confirmation: 'xxxxxxxx')
    user.valid?
    expect(user.errors[:name]).to include('入力がありません')
  end

  it 'メールアドレスが設定されていなければ無効' do
    user = User.new(name: 'user', password: 'xxxxxxxx', password_confirmation: 'xxxxxxxx')
    user.valid?
    expect(user.errors[:email]).to include('入力がありません')
  end

  it 'パスワードが20文字までなら有効' do
    password = 'abcde123456789012345'
    task = User.new(name: 'user', email: 'abc@xxx.com', password: password, password_confirmation: password)
    expect(task).to be_valid
  end

  it 'パスワードが20文字を超えると無効' do
    password = 'abcde1234567890123456'
    user = User.new(name: 'user', email: 'abc@xxx.com', password: password, password_confirmation: password)
    user.valid?
    expect(user.errors[:password]).to include('長すぎます')
  end

  it 'パスワードが8文字より短いと無効' do
    password = 'abcdefg'
    user = User.new(name: 'user', email: 'abc@xxx.com', password: password, password_confirmation: password)
    user.valid?
    expect(user.errors[:password]).to include('短すぎます')
  end

  it '確認用パスワードがパスワードと異なる場合は無効' do
    user = User.new(name: 'user', email: 'abc@xxx.com', password: 'xxxxxxxx', password_confirmation: '1xxxxxxx')
    user.valid?
    expect(user.errors[:password_confirmation]).to include('最初に入力したパスワードと一致しません')
  end

  it 'メールアドレスが重複している場合は無効' do
    User.create(name: 'user', email: 'abc@xxx.com', password: 'xxxxxxxx', password_confirmation: 'xxxxxxxx')
    user = User.new(name: 'user2', email: 'abc@xxx.com', password: 'xxxxxxxx', password_confirmation: 'xxxxxxxx')
    user.valid?
    expect(user.errors[:email]).to include('すでに登録されています')
  end
end
