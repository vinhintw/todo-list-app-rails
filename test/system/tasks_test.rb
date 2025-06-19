require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  setup do
    @task = tasks(:one)
    @user = users(:one)
    login_as(@user)
  end

  test "visiting the index" do
    visit tasks_url
    assert_selector "h1", text: "Tasks"
  end

  test "should create task" do
    visit tasks_url
    click_on "New task"

    fill_in "Title", with: "New Test Task"
    fill_in "Content", with: "Test content"
    fill_in "Start time", with: "2025-06-20T09:00"
    fill_in "End time", with: "2025-06-20T17:00"
    select "Medium", from: "Priority"
    select "Pending", from: "Status"
    click_on "Create Task"

    assert_text "Task was successfully created"
    click_on "Back"
  end

  test "should update Task" do
    visit task_url(@task)
    click_on "Edit this task", match: :first

    fill_in "Title", with: "Updated Task Title"
    fill_in "Content", with: "Updated content"
    fill_in "Start time", with: "2025-06-21T10:00"
    fill_in "End time", with: "2025-06-21T18:00"
    select "High", from: "Priority"
    select "In Progress", from: "Status"
    click_on "Update Task"

    assert_text "Task was successfully updated"
    click_on "Back"
  end

  test "should destroy Task" do
    visit task_url(@task)
    accept_confirm { click_on "Destroy this task", match: :first }

    assert_text "Task was successfully destroyed"
  end
end
