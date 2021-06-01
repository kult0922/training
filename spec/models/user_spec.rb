# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it '名前・メールアドレス・パスワードが設定されていれば有効' do
    user = User.new(name: 'user', email: 'abc@xxx.com', password: 'Ab12345+', password_confirmation: 'Ab12345+')
    expect(user).to be_valid
  end

  it '名前が設定されていなければ無効' do
    user = User.new(email: 'abc@xxx.com', password: 'Ab12345+', password_confirmation: 'Ab12345+')
    user.valid?
    expect(user.errors[:name]).to include('入力がありません')
  end

  it 'メールアドレスが設定されていなければ無効' do
    user = User.new(name: 'user', password: 'Ab12345+', password_confirmation: 'Ab12345+')
    user.valid?
    expect(user.errors[:email]).to include('入力がありません')
  end

  it 'パスワードが72文字を超えると無効' do
    password = 'Ab1234567890123456789012345678901234567890123456789012345678901234567890+'
    user = User.new(name: 'user', email: 'abc@xxx.com', password: password, password_confirmation: password)
    user.valid?
    expect(user.errors[:password]).to include('長すぎます')
  end

  it 'パスワードが8文字より短いと無効' do
    password = 'Ab1234+'
    user = User.new(name: 'user', email: 'abc@xxx.com', password: password, password_confirmation: password)
    user.valid?
    expect(user.errors[:password]).to include('短すぎます')
  end

  it 'パスワードに英大文字が含まれていないと無効' do
    password = 'ab12345+'
    user = User.new(name: 'user', email: 'abc@xxx.com', password: password, password_confirmation: password)
    user.valid?
    expect(user.errors[:password]).to include('無効なパスワードです。英大文字・英小文字・数字・記号を含めてください')
  end

  it 'パスワードに英小文字が含まれていないと無効' do
    password = 'AB12345+'
    user = User.new(name: 'user', email: 'abc@xxx.com', password: password, password_confirmation: password)
    user.valid?
    expect(user.errors[:password]).to include('無効なパスワードです。英大文字・英小文字・数字・記号を含めてください')
  end

  it 'パスワードに数字が含まれていないと無効' do
    password = 'abcdefg+'
    user = User.new(name: 'user', email: 'abc@xxx.com', password: password, password_confirmation: password)
    user.valid?
    expect(user.errors[:password]).to include('無効なパスワードです。英大文字・英小文字・数字・記号を含めてください')
  end

  it 'パスワードに記号が含まれていないと無効' do
    password = 'Ab123456'
    user = User.new(name: 'user', email: 'abc@xxx.com', password: password, password_confirmation: password)
    user.valid?
    expect(user.errors[:password]).to include('無効なパスワードです。英大文字・英小文字・数字・記号を含めてください')
  end

  it '確認用パスワードがパスワードと異なる場合は無効' do
    user = User.new(name: 'user', email: 'abc@xxx.com', password: 'Ab12345+', password_confirmation: 'Ab12346+')
    user.valid?
    expect(user.errors[:password_confirmation]).to include('最初に入力したパスワードと一致しません')
  end

  it 'メールアドレスが重複している場合は無効' do
    User.create(name: 'user', email: 'abc@xxx.com', password: 'Ab12345+', password_confirmation: 'Ab12345+')
    user = User.new(name: 'user2', email: 'abc@xxx.com', password: 'Ab12345+', password_confirmation: 'Ab12345+')
    user.valid?
    expect(user.errors[:email]).to include('すでに登録されています')
  end
end
