json.extract! task, :id, :title, :content, :start_time, :end_time, :priority, :status, :user_id, :created_at, :updated_at
json.url task_url(task, format: :json)
