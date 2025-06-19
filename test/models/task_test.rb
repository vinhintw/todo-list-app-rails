require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @task = Task.new(
      title: "Test Task",
      content: "Test content",
      start_time: 1.hour.from_now,
      end_time: 2.hours.from_now,
      priority: :medium,
      status: :pending,
      user: @user
    )
  end

  test "should be valid" do
    assert @task.valid?
  end

  test "title should be present" do
    @task.title = ""
    assert_not @task.valid?
  end

  test "title should not be too long" do
    @task.title = "a" * 256
    assert_not @task.valid?
  end

  test "content should not be too long" do
    @task.content = "a" * 5001
    assert_not @task.valid?
  end

  test "should belong to user" do
    @task.user = nil
    assert_not @task.valid?
  end

  test "priority enum should work" do
    @task.priority = :low
    assert @task.low?

    @task.priority = :high
    assert @task.high?

    @task.priority = :urgent
    assert @task.urgent?
  end

  test "status enum should work" do
    @task.status = :in_progress
    assert @task.in_progress?

    @task.status = :completed
    assert @task.completed?

    @task.status = :cancelled
    assert @task.cancelled?
  end

  test "end time should be after start time" do
    @task.start_time = 2.hours.from_now
    @task.end_time = 1.hour.from_now
    assert_not @task.valid?
    assert_includes @task.errors[:end_time], "must be after start time"
  end

  test "should accept nil start_time and end_time" do
    @task.start_time = nil
    @task.end_time = nil
    assert @task.valid?
  end

  test "should have many tags through taggings" do
    tag1 = Tag.create!(name: "urgent-task")
    tag2 = Tag.create!(name: "work-item")

    @task.save!
    @task.tags << tag1
    @task.tags << tag2

    assert_equal 2, @task.tags.count
    assert_includes @task.tags, tag1
    assert_includes @task.tags, tag2
  end
end
