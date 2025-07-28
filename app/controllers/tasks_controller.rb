class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    ransack_params = {}
    ransack_params[:title_cont] = params[:title] if params[:title].present?
    ransack_params[:status_eq] = params[:status] if params[:status].present?

    tasks_scope = current_user.tasks.includes(:tags)
    if params[:tag].present?
      tasks_scope = tasks_scope.joins(:tags).where(tags: { name: params[:tag] })
    end
    @q = tasks_scope.ransack(ransack_params)
    @tasks = @q.result.order(priority: :desc).page(params[:page]).per(15)
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: t("flash.task_created") }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: t("flash.task_updated") }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to tasks_path, status: :see_other, notice: t("flash.task_destroyed") }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.includes(:tags).find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def task_params
      permitted_params = params.expect(task: [ :title, :content, :start_time, :end_time, :priority, :status, :user_id, tag_ids: [] ])

      if permitted_params[:tag_ids].present?
        permitted_params[:tag_ids] = permitted_params[:tag_ids].reject(&:blank?).map(&:to_i)
      else
        permitted_params[:tag_ids] = []
      end
      permitted_params
    end
end
