class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  # role management
  enum :role, { normal: 0, admin: 1 }
  # validations user model
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, length: { minimum: 3 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  has_many :tasks, dependent: :destroy
end
