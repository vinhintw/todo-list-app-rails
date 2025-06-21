module TasksHelper
  def priority_badge_class(priority)
    case priority.to_s
    when "low"
      "bg-green-100 text-green-800"
    when "medium"
      "bg-yellow-100 text-yellow-800"
    when "high"
      "bg-orange-100 text-orange-800"
    when "urgent"
      "bg-red-100 text-red-800"
    else
      "bg-gray-100 text-gray-800"
    end
  end

  def status_badge_class(status)
    case status.to_s
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
  end
end
