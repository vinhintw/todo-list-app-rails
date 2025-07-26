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
end
