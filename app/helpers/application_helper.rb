module ApplicationHelper
  SIDEBAR_LINK_BASE_CLASS = "group flex items-center px-2 py-2 font-medium rounded-md text-base".freeze
  BADGE_BASE_CLASSES = "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium".freeze

  COLOR_MAPPINGS = {
    priority: {
      "low"    => "bg-gray-100 text-gray-800",
      "medium" => "bg-yellow-100 text-yellow-800",
      "high"   => "bg-orange-100 text-orange-800",
      "urgent" => "bg-red-100 text-red-800"
    }.freeze,
    status: {
      "pending"     => "bg-gray-100 text-gray-800",
      "in_progress" => "bg-blue-100 text-blue-800",
      "completed"   => "bg-green-100 text-green-800",
      "cancelled"   => "bg-red-100 text-red-800"
    }.freeze
  }.freeze

  NAV_STATUS_MAPPINGS = {
    0 => "bg-yellow-100 text-yellow-900",  # pending
    1 => "bg-blue-100 text-blue-900",     # in_progress
    2 => "bg-green-100 text-green-900",   # completed
    3 => "bg-red-100 text-red-900"        # cancelled
  }.freeze

  # Default fallback classes
  DEFAULT_BADGE_COLOR = "bg-gray-100 text-gray-800".freeze
  DEFAULT_NAV_COLOR = "bg-gray-100 text-gray-900".freeze
  INACTIVE_SIDEBAR_CLASS = "text-gray-600 hover:bg-gray-50 hover:text-gray-900".freeze
  ACTIVE_ALL_TASKS_CLASS = "bg-indigo-100 text-indigo-900".freeze

  # Status filter configuration
  STATUS_FILTERS = [
    { status: 0, label_key: "status.pending" },
    { status: 1, label_key: "status.in_progress" },
    { status: 2, label_key: "status.completed" },
    { status: 3, label_key: "status.cancelled" }
  ].freeze

  STATUS_STRING_TO_INT = {
    "pending" => 0,
    "in_progress" => 1,
    "completed" => 2,
    "cancelled" => 3
  }.freeze

  def badge_class(type, value)
    color_classes = COLOR_MAPPINGS.dig(type.to_sym, value) || DEFAULT_BADGE_COLOR
    "#{BADGE_BASE_CLASSES} #{color_classes}"
  end

  def badge(type, task)
    value = task.send(type)
    text = t("#{type}.#{value}") if value.present?
    content_tag :span, text, class: badge_class(type, value)
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def sidebar_brand_link
    link_to "TaskManager",
            root_path,
            class: "flex items-center text-xl font-bold text-indigo-600 hover:text-indigo-700"
  end
end
