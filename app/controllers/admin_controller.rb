class AdminController < ApplicationController
  before_action :set_user, only: %i[ edit update destroy user_tasks ]
  before_action :require_admin

  def index
    set_user_counts
    load_admin_users
    load_normal_users
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(signup_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_path, notice: t("flash.registration_successful") }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    remove_blank_password_params

    if prevent_self_demote!
      render :edit, status: :unprocessable_entity
      return
    end

    respond_to do |format|
      if @user.update(signup_params)
        format.html { redirect_to admin_path, notice: t("flash.user_updated") }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    return render_deletion_error("flash.cannot_delete_self") if @user == current_user
    respond_to do |format|
      if @user.destroy
        render_deletion_success(format)
      else
        render_deletion_errors(format)
      end
    end
  end

  def user_tasks
    @tasks = @user.tasks.ransack(status_eq: params[:status]).result.order(created_at: :desc).page(params[:page]).per(15)
  end

  private

  def render_deletion_success(format)
    format.html { redirect_to admin_path, status: :see_other, notice: t("flash.user_destroyed") }
  end

  def render_deletion_error(message_key)
    respond_to do |format|
      format.html { redirect_to admin_path, alert: t(message_key) }
    end
  end

  def render_deletion_errors(format)
    error_message = @user.errors.full_messages.first || t("flash.user_delete_failed")
    format.html { redirect_to admin_path, alert: error_message }
  end

  def prevent_self_demote!
    if @user == current_user && signup_params[:role] == "normal"
      @user.errors.add(:role, t("flash.user_cannot_demote"))
      return true
    end
    false
  end

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
    permitted = [ :username, :email_address, :password, :password_confirmation ]
    permitted << :role if current_user&.admin?
    params.require(:user).permit(permitted)
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path
    end
  end

  def set_user_counts
    counts = User.group(:role).count
    @admin_count = counts["admin"] || 0
    @normal_count = counts["normal"] || 0
    @total_users = @admin_count + @normal_count
  end

  def load_admin_users
    @admin_users = User.with_task_counts
                       .where(role: :admin)
                       .page(params[:admin_page])
                       .per(10)
  end

  def load_normal_users
    @normal_users = User.with_task_counts
                        .where(role: :normal)
                        .page(params[:normal_page])
                        .per(10)
  end
end
