require 'bcrypt'

FactoryBot.define do
  factory :user do
    name { 'raku' }
    encrypted_password { BCrypt::Password.create('raku') }
  end
end
