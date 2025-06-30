module ApplicationHelper
  # Helper to get CSS classes for task priority badge
  def priority_badge_class(priority)
    base_classes = "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"

    color_classes = case priority
    when "low"
      "bg-gray-100 text-gray-800"
    when "medium"
      "bg-yellow-100 text-yellow-800"
    when "high"
      "bg-orange-100 text-orange-800"
    when "urgent"
      "bg-red-100 text-red-800"
    else
      "bg-gray-100 text-gray-800"
    end

    "#{base_classes} #{color_classes}"
  end

  # Helper to get CSS classes for task status badge
  def status_badge_class(status)
    base_classes = "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"

    color_classes = case status
    when "pending"
      "bg-gray-100 text-gray-800"
    when "in_progress"
      "bg-blue-100 text-blue-800"
    when "completed"
      "bg-green-100 text-green-800"
    when "cancelled"
      "bg-red-100 text-red-800"
    else
      "bg-gray-100 text-gray-800"
    end

    "#{base_classes} #{color_classes}"
  end

  # Helper to render priority badge
  def priority_badge(task)
    content_tag :span, task.priority.capitalize, class: priority_badge_class(task.priority)
  end

  # Helper to render status badge
  def status_badge(task)
    content_tag :span, task.status.humanize, class: status_badge_class(task.status)
  end
end
