class AddIndexesToTasks < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pg_trgm' unless extension_enabled?('pg_trgm')
    add_index :tasks, :status
    add_index :tasks, :created_at
    add_index :tasks, :end_time
  end
end
