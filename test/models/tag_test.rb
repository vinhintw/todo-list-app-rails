require "test_helper"

class TagTest < ActiveSupport::TestCase
  def setup
    @tag = Tag.new(name: "test-tag")
  end

  test "should be valid" do
    assert @tag.valid?
  end

  test "name should be present" do
    @tag.name = ""
    assert_not @tag.valid?
  end

  test "name should be unique" do
    @tag.save!
    duplicate_tag = Tag.new(name: "test-tag")
    assert_not duplicate_tag.valid?
  end

  test "name should not be too long" do
    @tag.name = "a" * 51
    assert_not @tag.valid?
  end

  test "name should contain only valid characters" do
    valid_names = [ "test", "test-tag", "test_tag", "test123", "TEST" ]
    invalid_names = [ "test tag", "test@tag", "test.tag", "test!" ]

    valid_names.each do |name|
      @tag.name = name
      assert @tag.valid?, "#{name} should be valid"
    end

    invalid_names.each do |name|
      @tag.name = name
      assert_not @tag.valid?, "#{name} should not be valid"
    end
  end

  test "name should be normalized to lowercase" do
    @tag.name = "TEST-TAG"
    @tag.save!
    assert_equal "test-tag", @tag.name
  end

  test "name should be stripped of whitespace" do
    @tag.name = "  test-tag  "
    @tag.save!
    assert_equal "test-tag", @tag.name
  end

  test "should have many tasks through taggings" do
    user = users(:one)
    task1 = Task.create!(title: "Task 1", user: user, priority: :medium, status: :pending)
    task2 = Task.create!(title: "Task 2", user: user, priority: :high, status: :completed)

    @tag.save!
    @tag.tasks << task1
    @tag.tasks << task2

    assert_equal 2, @tag.tasks.count
    assert_includes @tag.tasks, task1
    assert_includes @tag.tasks, task2
  end
end
