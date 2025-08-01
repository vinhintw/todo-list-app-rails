class Tag < ApplicationRecord
  normalizes :name, with: ->(name) { name.strip.downcase }

  has_many :taggings, dependent: :destroy
  has_many :tasks, through: :taggings

  validates :name, presence: true
end
