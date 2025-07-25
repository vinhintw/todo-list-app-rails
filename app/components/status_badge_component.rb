class StatusBadgeComponent < ViewComponent::Base
  include ApplicationHelper

  def initialize(user:, status:, count:, color_class: "text-gray-900")
    @user = user
    @status = status
    @count = count
  end

  def color_classes
    ApplicationHelper::COLOR_MAPPINGS[:status]
  end
end
