class AdminController < ApplicationController
  before_action :set_user, only: %i[ edit update destroy user_tasks ]
  before_action :require_admin

  def index
    counts = User.group(:role).count
    @admin_count = counts["admin"] || 0
    @normal_count = counts["normal"] || 0
    @total_users = @admin_count + @normal_count

    @admin_users = User.includes(:tasks)
                       .where(role: :admin)
                       .page(params[:admin_page])
                       .per(10)

    @normal_users = User.includes(:tasks)
                        .where(role: :normal)
                        .page(params[:normal_page])
                        .per(10)

    # Preload task counts for each user
    preload_task_counts
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(signup_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_path, notice: t("flash.registration_successful") }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    remove_blank_password_params

    respond_to do |format|
      if @user.update(signup_params)
        format.html { redirect_to admin_path, notice: t("flash.user_updated") }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to admin_path, status: :see_other, notice: t("flash.user_destroyed") }
      format.json { head :no_content }
    end
  end

  def user_tasks
    @tasks = @user.tasks.order(created_at: :desc).page(params[:page]).per(15)
  end

  private

  def remove_blank_password_params
    if signup_params[:password].blank? && signup_params[:password_confirmation].blank?
      signup_params.delete(:password)
      signup_params.delete(:password_confirmation)
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def signup_params
    params.require(:user).permit(:username, :email_address, :password, :password_confirmation)
  end

  def preload_task_counts
    user_ids = (@admin_users.to_a + @normal_users.to_a).map(&:id)

    return if user_ids.empty?

    task_counts = Task.where(user_id: user_ids)
                      .group(:user_id, :status)
                      .count

    # Add task count methods to each user
    (@admin_users.to_a + @normal_users.to_a).each do |user|
      add_task_count_methods(user, task_counts)
    end
  end

  def add_task_count_methods(user, task_counts)
    user.define_singleton_method(:pending_tasks_count) { task_counts[[ user.id, "pending" ]] || 0 }
    user.define_singleton_method(:in_progress_tasks_count) { task_counts[[ user.id, "in_progress" ]] || 0 }
    user.define_singleton_method(:completed_tasks_count) { task_counts[[ user.id, "completed" ]] || 0 }
    user.define_singleton_method(:cancelled_tasks_count) { task_counts[[ user.id, "cancelled" ]] || 0 }
    user.define_singleton_method(:total_tasks_count) do
      task_counts.select { |key, _| key[0] == user.id }.values.sum
    end
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path
    end
  end
end
