class Task < ApplicationRecord
  belongs_to :user

  # Enums for priority and status
  enum :priority, { low: 0, medium: 1, high: 2, urgent: 3 }
  enum :status, { pending: 0, in_progress: 1, completed: 2, cancelled: 3 }

  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validates :content, length: { maximum: 5000 }
  validates :start_time, :end_time, presence: true, if: -> { start_time.present? || end_time.present? }
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    return unless start_time.present? && end_time.present?

    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end
end
