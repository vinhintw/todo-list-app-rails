class CreateTaggings < ActiveRecord::Migration[8.0]
  def change
    create_table :taggings do |t|
      t.references :task, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.datetime :assigned_at, default: -> { 'CURRENT_TIMESTAMP' }, null: false

      t.timestamps
    end
    add_index :taggings, [ :task_id, :tag_id ], unique: true
  end
end
