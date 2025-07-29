class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    ransack_params = {}
    ransack_params[:title_cont] = params[:title] if params[:title].present?
    ransack_params[:status_eq] = params[:status] if params[:status].present?

    @q = current_user.tasks.ransack(ransack_params)
    @tasks = @q.result.order(priority: :desc).page(params[:page]).per(15)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to @task, notice: t("flash.task_created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: t("flash.task_updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy!

    redirect_to tasks_path, status: :see_other, notice: t("flash.task_destroyed")
  end

  private
    def set_task
      @task = Task.find(params.expect(:id))
    end

    def task_params
      params.expect(task: [ :title, :content, :start_time, :end_time, :priority, :status, :user_id ])
    end
end
