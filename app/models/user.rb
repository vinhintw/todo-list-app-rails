class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :tasks, dependent: :destroy
  belongs_to :role

  # validations user model
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, length: { minimum: 3 }

  # ensure at least one admin user exists
  before_destroy :ensure_at_least_one_admin

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Role helper methods
  def admin?
    role&.admin?
  end

  def user?
    role&.user?
  end

  # Scopes for different role types
  scope :admin, -> { joins(:role).where(roles: { name: "admin" }) }
  scope :normal, -> { joins(:role).where(roles: { name: "user" }) }

  private

  def ensure_at_least_one_admin
    if admin? && User.admin.count <= 1
      errors.add(:base, "Cannot delete the last admin user.")
      throw :abort # Prevent deletion
    end
  end
end
