class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    @q = current_user.tasks.search_and_filter(search_params)
    @tasks = @q.result.ordered.page(params[:page]).per(15)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = current_user.tasks.build(task_params)

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
      @task = Task.includes(:tags).find(params.expect(:id))
    end

    def task_params
      params.expect(task: [ :title, :content, :start_time, :end_time, :priority, :status, tag_ids: [] ])
      .tap { |p| sanitize_tag_ids!(p) }
    end

    def sanitize_tag_ids!(params)
      if params[:tag_ids].present?
        params[:tag_ids] = params[:tag_ids].filter_map { |id| id.to_i if id.present? }
      else
        params[:tag_ids] = []
      end
    end

    def search_params
      params.permit(:title, :status, :tag, :page, :locale)
    end
end
