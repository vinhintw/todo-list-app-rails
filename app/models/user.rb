class User < ApplicationRecord
  has_secure_password

  has_many :tasks, dependent: :destroy
  belongs_to :role

  # validations user model
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, length: { minimum: 3 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :normal
  end

  def encrypted_password
    self.password_digest
  end
  scope :with_task_counts, -> { includes(:tasks) }

  TASK_STATUSES = %i[pending in_progress completed cancelled]

  TASK_STATUSES.each do |status|
    define_method("#{status}_tasks_count") do
      if association(:tasks).loaded?
        tasks.count { |task| task.public_send("#{status}?") }
      else
        tasks.public_send(status).count
      end
    end
  end

  def total_tasks_count
    association(:tasks).loaded? ? tasks.size : tasks.count
  end

  before_validation :set_default_role, on: :create

  def set_default_role
    if User.count == 0
      self.role ||= Role.find_by(name: Role::USER)
    else
      self.role ||= Role.find_by(name: Role::USER)
    end
  end

  def admin?
   role&.admin?
  end

  def user?
    role&.user?
  end

  def last_admin?
    admin? && User.joins(:role).where(roles: { name: Role::ADMIN }).count == 1
  end
end
