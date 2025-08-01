class Task < ApplicationRecord
  belongs_to :user

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  # Enums for priority and status
  enum :priority, { low: 0, medium: 1, high: 2, urgent: 3 }
  enum :status, { pending: 0, in_progress: 1, completed: 2, cancelled: 3 }

  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validates :content, length: { maximum: 5000 }
  validates :start_time, :end_time, presence: true, if: -> { start_time.present? || end_time.present? }
  validate :end_time_after_start_time

  def self.ransackable_attributes(auth_object = nil)
    %w[title status]
  end

  scope :ordered, -> { order(priority: :desc) }
  scope :with_tags, -> { includes(:tags) }
  scope :by_tag, ->(tag_id) { joins(:taggings).where(taggings: { tag_id: tag_id }).distinct }

  def self.search_and_filter(params)
    scope = with_tags
    scope = scope.by_tag(params[:tag]) if params[:tag].present?

    ransack_params = {}
    ransack_params[:title_cont] = params[:title] if params[:title].present?
    ransack_params[:status_eq] = params[:status] if params[:status].present?

    scope.ransack(ransack_params)
  end


  private

  def end_time_after_start_time
    return unless start_time.present? && end_time.present?

    if end_time <= start_time
      errors.add(:end_time, I18n.t("activerecord.errors.models.task.attributes.end_time.end_time_after_start"))
    end
  end
end
