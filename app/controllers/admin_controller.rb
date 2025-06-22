class AdminController < ApplicationController
  before_action :require_admin

  def index
    # Admin users with task statistics
    @admin_users = User.admin.includes(:tasks).page(params[:admin_page]).per(10)

    # Normal users with task statistics
    @normal_users = User.normal.includes(:tasks).page(params[:normal_page]).per(10)

    # General statistics
    @total_users = User.count
    @admin_users_count = User.admin.count
    @normal_users_count = User.normal.count
    @total_tasks = Task.count
  end

  def user_details
    @user = User.find(params[:id])
    @tasks = @user.tasks.includes(:tags).page(params[:page]).per(10)

    # Statistics for this user
    @pending_count = @user.tasks.pending.count
    @in_progress_count = @user.tasks.in_progress.count
    @completed_count = @user.tasks.completed.count
    @cancelled_count = @user.tasks.cancelled.count
    @total_tasks = @user.tasks.count

    # Filter by status if requested
    if params[:status].present?
      case params[:status]
      when "pending"
        @tasks = @user.tasks.pending.includes(:tags).page(params[:page]).per(10)
      when "in_progress"
        @tasks = @user.tasks.in_progress.includes(:tags).page(params[:page]).per(10)
      when "completed"
        @tasks = @user.tasks.completed.includes(:tags).page(params[:page]).per(10)
      when "cancelled"
        @tasks = @user.tasks.cancelled.includes(:tags).page(params[:page]).per(10)
      end
    end
  end

  def destroy_user
    @user = User.find(params[:id])

    if @user == Current.user
      redirect_to admin_path, alert: "You cannot delete your own account."
      return
    end

    username = @user.username
    @user.destroy

    redirect_to admin_path, notice: "Successfully deleted user #{username} and all related data."
  end

  private

  def require_admin
    unless Current.user&.admin?
      redirect_to root_path, alert: "You do not have access to this page."
    end
  end
end
