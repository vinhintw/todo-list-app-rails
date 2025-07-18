# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_18_110000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title", null: false
    t.text "content"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "priority"
    t.integer "status"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_tasks_on_created_at"
    t.index ["end_time"], name: "index_tasks_on_end_time"
    t.index ["status"], name: "index_tasks_on_status"
    t.index ["user_id"], name: "index_tasks_on_user_id"
    t.check_constraint "content IS NULL OR length(content) <= 5000", name: "content_length_check"
    t.check_constraint "length(title::text) <= 255", name: "title_length_check"
    t.check_constraint "priority = ANY (ARRAY[0, 1, 2, 3])", name: "priority_enum_check"
    t.check_constraint "start_time IS NULL OR end_time IS NULL OR end_time > start_time", name: "end_time_after_start_time_check"
    t.check_constraint "status = ANY (ARRAY[0, 1, 2, 3])", name: "status_enum_check"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.string "username", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "role_id", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "tasks", "users"
  add_foreign_key "users", "roles"
end
