class Role < ApplicationRecord
  has_many :users, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true

  before_destroy :ensure_users_not_assigned

  # Predefined role names
  ADMIN = "admin".freeze
  USER = "user".freeze

  scope :admin, -> { where(name: ADMIN) }
  scope :user, -> { where(name: USER) }

  def admin?
    name.downcase == ADMIN
  end

  def user?
    name.downcase == USER
  end

  private

  def ensure_users_not_assigned
    if users.exists?
      errors.add(:base, "Cannot delete role that has users assigned to it")
      throw :abort
    end
  end
end
