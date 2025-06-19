require "test_helper"

class TaggingTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @task = Task.create!(title: "Test Task", user: @user, priority: :medium, status: :pending)
    @tag = Tag.create!(name: "test")
    @tagging = Tagging.new(task: @task, tag: @tag)
  end

  test "should be valid" do
    assert @tagging.valid?
  end

  test "should belong to task" do
    @tagging.task = nil
    assert_not @tagging.valid?
  end

  test "should belong to tag" do
    @tagging.tag = nil
    assert_not @tagging.valid?
  end

  test "should not allow duplicate task-tag combinations" do
    @tagging.save!
    duplicate_tagging = Tagging.new(task: @task, tag: @tag)
    assert_not duplicate_tagging.valid?
    assert_includes duplicate_tagging.errors[:task_id], "has already been tagged with this tag"
  end

  test "should allow same tag on different tasks" do
    task2 = Task.create!(title: "Task 2", user: @user, priority: :high, status: :completed)
    @tagging.save!

    tagging2 = Tagging.new(task: task2, tag: @tag)
    assert tagging2.valid?
  end

  test "should allow same task with different tags" do
    tag2 = Tag.create!(name: "another-tag")
    @tagging.save!

    tagging2 = Tagging.new(task: @task, tag: tag2)
    assert tagging2.valid?
  end

  test "should have assigned_at timestamp" do
    @tagging.save!
    assert_not_nil @tagging.assigned_at
    assert @tagging.assigned_at <= Time.current
  end
end
