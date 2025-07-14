class AdminController < ApplicationController
  def index
    @users = User.includes(:tasks)
    @admin_users = @users.select { |user| user.role == "admin" }
    @normal_users = @users.select { |user| user.role == "normal" }

    @user_counts = @users.group_by(&:role).transform_values(&:count)

    @admin_count = @user_counts["admin"] || 0
    @normal_count = @user_counts["normal"] || 0

    @total_users = @admin_count + @normal_count

    # Preload task counts for each user
    preload_task_counts
  end

  private

  def preload_task_counts
    user_ids = @users.map(&:id)

    task_counts = Task.where(user_id: user_ids)
                     .group(:user_id, :status)
                     .count

    # Add task count methods to each user
    @users.each do |user|
      user.define_singleton_method(:pending_tasks_count) { task_counts[[ user.id, "pending" ]] || 0 }
      user.define_singleton_method(:in_progress_tasks_count) { task_counts[[ user.id, "in_progress" ]] || 0 }
      user.define_singleton_method(:completed_tasks_count) { task_counts[[ user.id, "completed" ]] || 0 }
      user.define_singleton_method(:cancelled_tasks_count) { task_counts[[ user.id, "cancelled" ]] || 0 }

      # Add a method to get the total task count for the user
      user.define_singleton_method(:total_tasks_count) do
        task_counts.select { |key, _| key[0] == user.id }.values.sum
      end
    end
  end
end
