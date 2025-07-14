module AdminHelper
  # Render task count badge with appropriate styling
  def task_count_badge(count, status)
    color_classes = {
      "pending" => "bg-yellow-100 text-yellow-800",
      "in_progress" => "bg-blue-100 text-blue-800",
      "completed" => "bg-green-100 text-green-800",
      "cancelled" => "bg-red-100 text-red-800",
      "total" => "bg-gray-100 text-gray-800"
    }

    content_tag :span, count,
                class: "inline-flex px-2 py-1 text-xs font-semibold rounded-full #{color_classes[status]}"
  end

  # Render statistics card
  def statistics_card(title_key, count, color_class = "text-gray-900")
    content_tag :div, class: "bg-white rounded-lg shadow p-6" do
      content_tag :div, class: "flex items-center" do
        content_tag :div, class: "ml-4" do
          concat content_tag(:p, t(title_key), class: "text-sm font-medium text-gray-500")
          concat content_tag(:p, count, class: "text-2xl font-bold #{color_class}")
        end
      end
    end
  end

  # Render user table
  def render_user_table(users, table_type)
    title_key = table_type == :admin ? "admin.dashboard.administrators" : "admin.dashboard.normal_users"

    content_tag :div, class: "bg-white shadow rounded-lg #{'mb-8' if table_type == :admin}" do
      concat render_table_header(title_key, users.count)
      concat render_table_content(users)
      concat render_empty_state if table_type == :normal && users.empty?
    end
  end

  private

  def render_table_header(title_key, count)
    content_tag :div, class: "px-6 py-4 border-b border-gray-200" do
      content_tag :h2, "#{t(title_key)} (#{count})",
                  class: "text-lg font-medium text-gray-900"
    end
  end

  def render_table_content(users)
    content_tag :div, class: "overflow-x-auto" do
      content_tag :table, class: "min-w-full divide-y divide-gray-200" do
        concat render_table_thead
        concat render_table_tbody(users)
      end
    end
  end

  def render_table_thead
    content_tag :thead, class: "bg-gray-50" do
      content_tag :tr do
        table_headers.map do |header|
          content_tag :th, t(header[:key]),
                      class: "px-6 py-3 text-#{header[:align]} text-xs font-medium text-gray-500 uppercase tracking-wider"
        end.join.html_safe
      end
    end
  end

  def render_table_tbody(users)
    content_tag :tbody, class: "bg-white divide-y divide-gray-200" do
      users.map do |user|
        content_tag :tr, class: "hover:bg-gray-50" do
          concat render_user_info_cell(user)
          concat render_email_cell(user)
          concat render_task_count_cell(user.pending_tasks_count, "pending")
          concat render_task_count_cell(user.in_progress_tasks_count, "in_progress")
          concat render_task_count_cell(user.completed_tasks_count, "completed")
          concat render_task_count_cell(user.cancelled_tasks_count, "cancelled")
          concat render_task_count_cell(user.total_tasks_count, "total")
          concat render_actions_cell
        end
      end.join.html_safe
    end
  end

  def render_user_info_cell(user)
    content_tag :td, class: "px-6 py-4 whitespace-nowrap" do
      content_tag :div, class: "flex items-center" do
        content_tag :div, class: "ml-4" do
          content_tag :div, user.username,
                      class: "text-sm font-medium text-gray-900"
        end
      end
    end
  end

  def render_email_cell(user)
    content_tag :td, user.email_address,
                class: "px-6 py-4 whitespace-nowrap text-sm text-gray-900"
  end

  def render_task_count_cell(count, status)
    content_tag :td, class: "px-6 py-4 whitespace-nowrap text-center" do
      task_count_badge(count, status)
    end
  end

  def render_actions_cell
    content_tag :td, class: "px-6 py-4 whitespace-nowrap text-center" do
      content_tag :button, t("admin.dashboard.view_details"),
                  class: "text-indigo-600 hover:text-indigo-900 text-sm font-medium"
    end
  end

  def render_empty_state
    content_tag :div, class: "text-center py-8" do
      content_tag :h3, t("admin.dashboard.no_normal_found"),
                  class: "mt-2 text-xl font-medium text-gray-900"
    end
  end

  def table_headers
    [
      { key: "admin.dashboard.username", align: "left" },
      { key: "admin.dashboard.email", align: "left" },
      { key: "admin.dashboard.pending", align: "center" },
      { key: "admin.dashboard.in_progress", align: "center" },
      { key: "admin.dashboard.completed", align: "center" },
      { key: "admin.dashboard.cancelled", align: "center" },
      { key: "admin.dashboard.total", align: "center" },
      { key: "admin.dashboard.actions", align: "center" }
    ]
  end
end
