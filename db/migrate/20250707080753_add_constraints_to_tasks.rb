class AddConstraintsToTasks < ActiveRecord::Migration[8.0]
  def change
    change_column_null :tasks, :title, false

    add_check_constraint :tasks, "LENGTH(title) <= 255", name: "title_length_check"

    add_check_constraint :tasks, "content IS NULL OR LENGTH(content) <= 5000", name: "content_length_check"

    add_check_constraint :tasks,
      "start_time IS NULL OR end_time IS NULL OR end_time > start_time",
      name: "end_time_after_start_time_check"

    add_check_constraint :tasks, "priority IN (0, 1, 2, 3)", name: "priority_enum_check"

    add_check_constraint :tasks, "status IN (0, 1, 2, 3)", name: "status_enum_check"
  end
end
