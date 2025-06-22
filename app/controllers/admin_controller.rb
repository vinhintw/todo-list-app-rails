class AdminController < ApplicationController
  before_action :require_admin

  def index
    # Base query for all users with task statistics and role information
    @users = User.includes(:tasks, :role)

    # Filter by role if requested
    if params[:role].present?
      @users = @users.joins(:role).where(roles: { name: params[:role] })
    end

    # Paginate results
    @users = @users.page(params[:page]).per(10)

    # Get all roles with user counts for filter buttons
    @roles = Role.left_joins(:users).group(:id, :name).select("roles.*, COUNT(users.id) as user_count").order(:name)

    # General statistics
    @total_users = User.count
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

  def update_user_role
    @user = User.find(params[:id])
    @role = Role.find(params[:role_id])

    if @user == Current.user && !@role.admin?
      redirect_to admin_path, alert: "You cannot remove your own admin privileges."
      return
    end

    @user.update!(role: @role)
    redirect_to admin_path, notice: "Successfully updated #{@user.username}'s role to #{@role.name}."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to admin_path, alert: "Failed to update role: #{e.message}"
  end

  # Role management
  def roles
    @roles = Role.all.includes(:users)
    @new_role = Role.new
  end

  def create_role
    @role = Role.new(role_params)

    if @role.save
      redirect_to admin_roles_path, notice: "Role '#{@role.name}' created successfully."
    else
      @roles = Role.all.includes(:users)
      @new_role = @role
      render :roles, status: :unprocessable_entity
    end
  end

  def destroy_role
    @role = Role.find(params[:id])

    if @role.users.exists?
      redirect_to admin_roles_path, alert: "Cannot delete role '#{@role.name}' because it has users assigned to it."
      return
    end

    if @role.admin?
      redirect_to admin_roles_path, alert: "Cannot delete the admin role."
      return
    end

    role_name = @role.name
    @role.destroy
    redirect_to admin_roles_path, notice: "Role '#{role_name}' deleted successfully."
  end

  private

  def require_admin
    unless Current.user&.admin?
      redirect_to root_path, alert: "You do not have access to this page."
    end
  end

  def role_params
    params.require(:role).permit(:name, :description)
  end
end
