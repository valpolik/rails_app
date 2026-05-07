class User < ApplicationRecord
  # has_many :posts, dependent: :destroy
  has_secure_password
  normalizes :email, with: -> email { email.strip.downcase }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }

  generates_token_for :authentication, expires_in: 1.year do
    password_digest&.last(4)
  end
end
