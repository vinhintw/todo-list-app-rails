# frozen_string_literal: true

class UserTableComponent < ViewComponent::Base
  def initialize(users:, table_type:)
    @users = users
    @table_type = table_type
    @title_key = title_key_for_table_type
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

  private

  def title_key_for_table_type
    case @table_type
    when :admin
      "admin.dashboard.administrators"
    when :normal
      "admin.dashboard.normal_users"
    else
      "admin.dashboard.users"
    end
  end
end
