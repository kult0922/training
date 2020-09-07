class User < ApplicationRecord
    VALID_EMAIL_REGEX = /\A(?!.*(\.\..*@.*|\.@.*))(?!\.)[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[\d])\w{6,20}\z/
    has_many :task
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
    validates :password, presence: true,
        format: { with: VALID_PASSWORD_REGEX,
            message: 'は半角6~20文字英大文字・小文字・数字それぞれ１文字以上含む必要があります' }
end
