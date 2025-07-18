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

    if prevent_self_demote!
      render :edit, status: :unprocessable_entity
      return
    end

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
    if @user == current_user
      respond_to do |format|
        format.html { redirect_to admin_path, alert: t("flash.cannot_delete_self") }
        format.json { render json: { error: t("flash.cannot_delete_self") }, status: :forbidden }
      end
      return
    end

    if @user.last_admin?
      respond_to do |format|
        format.html { redirect_to admin_path, alert: t("flash.cannot_delete_last_admin") }
        format.json { render json: { error: t("flash.cannot_delete_last_admin") }, status: :forbidden }
      end
      return
    end

    @user.destroy!

    respond_to do |format|
      format.html { redirect_to admin_path, status: :see_other, notice: t("flash.user_destroyed") }
      format.json { head :no_content }
    end
  end

  def user_tasks
    @tasks = @user.tasks.ransack(status_eq: params[:status]).result.order(created_at: :desc).page(params[:page]).per(15)
  end

  def create_role
    @role = Role.new
  end

  def store_role
    @role = Role.new(role_params)
    if @role.save
      redirect_to admin_path, notice: t("role.created", name: @role.name)
    else
      render :create_role, status: :unprocessable_entity
    end
  end

  private

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
      redirect_to root_path, notice: t("flash.admin_access_denied")
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

  def role_params
    params.require(:role).permit(:name, :description)
  end
end
