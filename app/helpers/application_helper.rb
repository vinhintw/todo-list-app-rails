module ApplicationHelper
  def badge_class(type, value)
    base_classes = "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"

    color_mappings = {
      priority: {
        "low"    => "bg-gray-100 text-gray-800",
        "medium" => "bg-yellow-100 text-yellow-800",
        "high"   => "bg-orange-100 text-orange-800",
        "urgent" => "bg-red-100 text-red-800"
      },
      status: {
        "pending"     => "bg-gray-100 text-gray-800",
        "in_progress" => "bg-blue-100 text-blue-800",
        "completed"   => "bg-green-100 text-green-800",
        "cancelled"   => "bg-red-100 text-red-800"
      }
    }

    color_classes = color_mappings[type.to_sym][value] || "bg-gray-100 text-gray-800"
    "#{base_classes} #{color_classes}"
  end

  def badge(type, task)
    value = task.send(type)
    text = type == :priority ? value.capitalize : value.humanize
    content_tag :span, text, class: badge_class(type, value)
  end
end
