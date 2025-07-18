class Role < ApplicationRecord
  has_many :users, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true

   ADMIN = "admin".freeze
   USER = "user".freeze

  def admin?
    name.downcase == ADMIN
  end

  def user?
    name.downcase == USER
  end
end
