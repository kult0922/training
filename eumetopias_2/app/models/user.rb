class User < ApplicationRecord

    has_many :task

    has_secure_password

    validates :name, presence: true
    VALID_EMAIL_REGEX = /\A(?!.*(\.\..*@.*|\.@.*))(?!\.)[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
    VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[\d])\w{6,20}\z/
    validates :password, presence: true,
        format: { with: VALID_PASSWORD_REGEX,
            message: 'は半角6~20文字英大文字・小文字・数字それぞれ１文字以上含む必要があります' }
end
