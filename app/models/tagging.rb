class Tagging < ApplicationRecord
  belongs_to :task
  belongs_to :tag
  validates :task_id, uniqueness: { scope: :tag_id, message: "has already been tagged with this tag" }
end
