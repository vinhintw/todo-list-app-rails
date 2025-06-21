class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :tasks, through: :taggings

  # Validations
  validates :name, presence: true, uniqueness: true, length: { minimum: 1, maximum: 50 }
  validates :name, format: { with: /\A[a-zA-Z0-9_-]+\z/, message: "can only contain letters, numbers, hyphens and underscores" }, if: -> { name.present? }

  # Normalize name to lowercase
  before_validation :normalize_name

  private

  def normalize_name
    self.name = name.strip.downcase if name.present?
  end
end
