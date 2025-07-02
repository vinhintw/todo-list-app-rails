class Tag < ApplicationRecord
  normalizes :name, with: ->(name) { name.strip.downcase }

  has_many :taggings, dependent: :destroy
  has_many :tasks, through: :taggings

  # Validations
  validates :name, presence: true,
                   uniqueness: true,
                   length: { minimum: 1, maximum: 50 },
                   format: { with: /\A[a-zA-Z0-9_-]+\z/, message: "can only contain letters, numbers, hyphens and underscores" }
end
