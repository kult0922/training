require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:valid_email) { 'example@example.com' }
  let!(:valid_password) { 'examplePASSWORD12345' }
  let!(:valid_name) { 'example_name' }

  describe 'name' do
    it 'not filled' do
      errors = validate_name('')
      expect(errors[:name]).to include('を入力してください')
    end
    describe 'have' do
      let(:test_user) { create(:test_user) }
      it 'duplicated' do
        errors = validate_name(test_user.name)
        expect(errors[:name]).to include('はすでに存在します')
      end
    end
    describe 'invalid lentgh' do
      it 'less than 2' do
        errors = validate_name('a')
        expect(errors[:name]).to include('は2文字以上で入力してください')
      end
      it 'over 50' do
        errors = validate_name('a' * 51)
        expect(errors[:name]).to include('は50文字以内で入力してください')
      end
    end
  end

  describe 'email' do
    it 'not filled' do
      errors = validate_email('')
      expect(errors[:email]).to include('を入力してください')
    end
    describe 'have' do
      let(:test_user) { create(:test_user) }
      it 'duplicated' do
        errors = validate_email(test_user.email)
        expect(errors[:email]).to include('はすでに存在します')
      end
    end
    describe 'invalid input' do
      let(:email_error_message) { 'は不正な値です' }
      it 'start with .' do
        errors = validate_email('.example@example.com')
        expect(errors[:email]).to include(email_error_message)
      end
      it 'have repeat .' do
        errors = validate_email('exam..ple@example.com')
        expect(errors[:email]).to include(email_error_message)
      end
      it 'have . before @' do
        errors = validate_email('example.@example.com')
        expect(errors[:email]).to include(email_error_message)
      end
      it 'without @' do
        errors = validate_email('exampleatexample.com')
        expect(errors[:email]).to include(email_error_message)
      end
      it 'without . after @' do
        errors = validate_email('example@examplecom')
        expect(errors[:email]).to include(email_error_message)
      end
    end
  end

  describe 'password' do
    it 'not filled' do
      errors = validate_password('')
      expect(errors[:password]).to include('を入力してください')
    end
    describe 'invalid input' do
      let(:password_error_message) { 'は半角6~20文字英大文字・小文字・数字それぞれ１文字以上含む必要があります' }
      it 'length less than 6' do
        errors = validate_password('aA9')
        expect(errors[:password]).to include(password_error_message)
      end
      it 'length over 20' do
        errors = validate_password('aaaaaaaaaaAAAAAAAAAA0000000000')
        expect(errors[:password]).to include(password_error_message)
      end
      it 'without small letter' do
        errors = validate_password('AAAA0000')
        expect(errors[:password]).to include(password_error_message)
      end
      it 'without capital letter' do
        errors = validate_password('aaaa0000')
        expect(errors[:password]).to include(password_error_message)
      end
      it 'without numerical characters' do
        errors = validate_password('aaaAAA')
        expect(errors[:password]).to include(password_error_message)
      end
    end
  end

  def validate_name(name)
    validate_user(name, valid_email, valid_password)
  end

  def validate_email(email)
    validate_user(valid_name, email, valid_password)
  end

  def validate_password(password)
    validate_user(valid_name, valid_email, password)
  end

  def validate_user(name, email, password)
    user = User.new(name: name, email: email, password: password)
    user.valid?
    user.errors.messages
  end
end
