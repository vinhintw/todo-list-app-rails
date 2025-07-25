# frozen_string_literal: true

class UserTableComponent < ViewComponent::Base
  def initialize(users:, table_type:)
    @users = users
    @table_type = table_type
    @title_key = table_type == :admin ? "admin.dashboard.administrators" : "admin.dashboard.normal_users"
  end

  def table_headers
    [
      { key: "admin.dashboard.username", align: "left" },
      { key: "admin.dashboard.email", align: "left" },
      { key: "status.pending", align: "center" },
      { key: "status.in_progress", align: "center" },
      { key: "status.completed", align: "center" },
      { key: "status.cancelled", align: "center" },
      { key: "admin.dashboard.total", align: "center" },
      { key: "admin.dashboard.actions", align: "center" }
    ]
  end

  def color_classes
    {
      "pending" => "bg-yellow-100 text-yellow-800",
      "in_progress" => "bg-blue-100 text-blue-800",
      "completed" => "bg-green-100 text-green-800",
      "cancelled" => "bg-red-100 text-red-800",
      "total" => "bg-gray-100 text-gray-800"
    }
  end
end
