class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  # role management
  enum :role, { normal: 0, admin: 1 }
  # validations
  validates :username, presence: true, uniqueness: true, length: { minimum: 3 }
  validates :email_address, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9]([a-zA-Z0-9._%+-]*[a-zA-Z0-9])?@[a-zA-Z0-9]([a-zA-Z0-9.-]*[a-zA-Z0-9])?\.[a-zA-Z]{2,}\z/ }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  # ensure at least one admin user exists
  before_destroy :ensure_at_least_one_admin
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  private

  def ensure_at_least_one_admin
    if admin? && User.where(role: :admin).count <= 1
      errors.add(:base, "Cannot delete the last admin user.")
      throw :abort # Prevent deletion
    end
  end

  has_many :tasks, dependent: :destroy
end
