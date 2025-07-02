class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    @tasks = filter_tasks(Current.user.tasks.includes(:tags))
  end

  def all
    @tasks = filter_tasks(Current.user.tasks.includes(:tags))
    render :index
  end

  # GET /tasks/pending
  def pending
    @tasks = filter_tasks(Current.user.tasks.pending.includes(:tags))
    render :index
  end

  # GET /tasks/in_progress
  def in_progress
    @tasks = filter_tasks(Current.user.tasks.in_progress.includes(:tags))
    render :index
  end

  # GET /tasks/completed
  def completed
    @tasks = filter_tasks(Current.user.tasks.completed.includes(:tags))
    render :index
  end

  # GET /tasks/cancelled
  def cancelled
    @tasks = filter_tasks(Current.user.tasks.cancelled.includes(:tags))
    render :index
  end

  # GET /tasks/low_priority
  def low_priority
    @tasks = filter_tasks(Current.user.tasks.low.includes(:tags))
    render :index
  end

  # GET /tasks/medium_priority
  def medium_priority
    @tasks = filter_tasks(Current.user.tasks.medium.includes(:tags))
    render :index
  end

  # GET /tasks/high_priority
  def high_priority
    @tasks = filter_tasks(Current.user.tasks.high.includes(:tags))
    render :index
  end

  # GET /tasks/urgent_priority
  def urgent_priority
    @tasks = filter_tasks(Current.user.tasks.urgent.includes(:tags))
    render :index
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
        format.html { redirect_to @task, notice: "Task was successfully created." }
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
        format.html { redirect_to @task, notice: "Task was successfully updated." }
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
      format.html { redirect_to tasks_path, status: :see_other, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.expect(task: [ :title, :content, :start_time, :end_time, :priority, :status, :user_id ])
    end

    # Filter tasks based on search and tag parameters
    def filter_tasks(tasks)
      tasks = tasks.where("title ILIKE ? OR content ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?
      tasks = tasks.joins(:tags).where(tags: { name: params[:tag] }) if params[:tag].present?

      # Apply sorting based on sort parameter
      case params[:sort]
      when "priority_asc"
        tasks.order(:priority)
      when "priority_desc"
        tasks.order(priority: :desc)
      when "start_time_asc"
        tasks.order(:start_time)
      when "start_time_desc"
        tasks.order(start_time: :desc)
      when "end_time_asc"
        tasks.order(:end_time)
      when "end_time_desc"
        tasks.order(end_time: :desc)
      when "created_asc"
        tasks.order(:created_at)
      else
        tasks.order(created_at: :desc)
      end
    end
end
