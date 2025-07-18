class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy
  belongs_to :role

  # validations user model
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, length: { minimum: 3 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def encrypted_password
    self.password_digest
  end

  before_validation :set_default_role, on: :create

  def set_default_role
    if User.count == 0
      self.role ||= Role.find_by(name: "admin")
    else
      self.role ||= Role.find_by(name: "user")
    end
  end

  def admin?
   role&.admin?
  end

  def user?
    role&.user?
  end
end
