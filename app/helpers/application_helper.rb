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
    text = t("#{type}.#{value}") if value.present?
    content_tag :span, text, class: badge_class(type, value)
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def sidebar_link_class(current_status = nil)
    base_class = "group flex items-center px-2 py-2 text-md font-medium rounded-md"
    inactive_class = "text-gray-600 hover:bg-gray-50 hover:text-gray-900"

    return "#{base_class} #{inactive_class}" unless current_status && params[:status] == current_status.to_s

    nav_status_mappings = {
      0 => "bg-yellow-100 text-yellow-900",  # pending
      1 => "bg-blue-100 text-blue-900",     # in_progress
      2 => "bg-green-100 text-green-900",   # completed
      3 => "bg-red-100 text-red-900"        # cancelled
    }

    active_class = nav_status_mappings[current_status] || "bg-gray-100 text-gray-900"
    "#{base_class} #{active_class}"
  end

  def all_tasks_link_class
    base_class = "group flex items-center px-2 py-2 text-base font-medium rounded-md"
    if params[:status].blank?
      "#{base_class} bg-indigo-100 text-indigo-900"
    else
      "#{base_class} text-gray-600 hover:bg-gray-50 hover:text-gray-900"
    end
  end

  def status_filter_link(status, label_key)
    link_to t(label_key),
            tasks_path(status: status, title: params[:title]),
            class: sidebar_link_class(status)
  end

  def status_filters
    [
      { status: 0, label_key: "status.pending" },
      { status: 1, label_key: "status.in_progress" },
      { status: 2, label_key: "status.completed" },
      { status: 3, label_key: "status.cancelled" }
    ]
  end

  def render_status_filters
    status_filters.map do |filter|
      status_filter_link(filter[:status], filter[:label_key])
    end.join.html_safe
  end

  def sidebar_brand_link
    link_to "TaskManager",
            root_path,
            class: "flex items-center text-xl font-bold text-indigo-600 hover:text-indigo-700"
  end
end
