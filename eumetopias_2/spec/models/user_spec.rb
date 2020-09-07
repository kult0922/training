require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:valid_email) { 'example@example.com' }
  let!(:valid_password) { 'examplePASSWORD12345' }
  let!(:valid_name) { 'example_name' }

  it 'is invalid without name, email and password' do
    new_user = User.new()
    new_user.valid?
    expect(new_user.errors.messages[:name]).to include('を入力してください')
    expect(new_user.errors.messages[:email]).to include('を入力してください')
    expect(new_user.errors.messages[:password]).to include('を入力してください')
  end

  describe 'returns error with duplicate' do
    before do
      @test_user = create(:test_user)
    end
    it 'name' do
      user = User.new(name: @test_user.name, email: 'random@example.com', password: valid_password)
      user.valid?
      expect(user.errors.messages[:name]).to include('はすでに存在します')
    end
    it 'email' do
      user = User.new(name: 'random name', email: @test_user.email, password: valid_password)
      user.valid?
      expect(user.errors.messages[:email]).to include('はすでに存在します')
    end
  end

  describe 'returns error with invalid name' do
    it 'lentgh less than 2' do
      user = User.new(name: 'a', email: valid_email, password: valid_password)
      user.valid?
      expect(user.errors.messages[:name]).to include('は2文字以上で入力してください')
    end
    it 'length over 50' do
      user = User.new(name: 'a' * 51, email: valid_email, password: valid_password)
      user.valid?
      expect(user.errors.messages[:name]).to include('は50文字以内で入力してください')
    end
  end

  describe 'returns error with invalid email' do
    before { @email_error_message = 'は不正な値です' }
    it 'start with .' do
      user = User.new(name: valid_name, email: '.example@example.com', password: valid_password)
      user.valid?
      expect(user.errors.messages[:email]).to include(@email_error_message)
    end
    it 'have repeat .' do
      user = User.new(name: valid_name, email: 'exam..ple@example.com', password: valid_password)
      user.valid?
      expect(user.errors.messages[:email]).to include(@email_error_message)
    end
    it 'have . before @' do
      user = User.new(name: valid_name, email: 'example.@example.com', password: valid_password)
      user.valid?
      expect(user.errors.messages[:email]).to include(@email_error_message)
    end
    it 'without @' do
      user = User.new(name: valid_name, email: 'exampleatexample.com', password: valid_password)
      user.valid?
      expect(user.errors.messages[:email]).to include(@email_error_message)
    end
    it 'without . after @' do
      user = User.new(name: valid_name, email: 'example@examplecom', password: valid_password)
      user.valid?
      expect(user.errors.messages[:email]).to include(@email_error_message)
    end
  end

  describe 'returns error with invalid password' do
    before { @password_error_message = 'は半角6~20文字英大文字・小文字・数字それぞれ１文字以上含む必要があります' }
    it 'length less than 6' do
      user = User.new(name: valid_name, email: valid_email, password: 'aA9')
      user.valid?
      expect(user.errors.messages[:password]).to include(@password_error_message)
    end
    it 'length over 20' do
      user = User.new(name: valid_name, email: valid_email, password: 'aaaaaaaaaaAAAAAAAAAA0000000000')
      user.valid?
      expect(user.errors.messages[:password]).to include(@password_error_message)
    end
    it 'without small letter' do
      user = User.new(name: valid_name, email: valid_email, password: 'AAAA0000')
      user.valid?
      expect(user.errors.messages[:password]).to include(@password_error_message)
    end
    it 'without capital letter' do
      user = User.new(name: valid_name, email: valid_email, password: 'aaaa0000')
      user.valid?
      expect(user.errors.messages[:password]).to include(@password_error_message)
    end
    it 'without numerical characters' do
      user = User.new(name: valid_name, email: valid_email, password: 'aaaaAAAA')
      user.valid?
      expect(user.errors.messages[:password]).to include(@password_error_message)
    end
  end
end
