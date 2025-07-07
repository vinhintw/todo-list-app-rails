require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    @user = User.create(email_address: "test@example.com", password: "password", username: "testuser")
  end

  it "is valid with valid attributes" do
    task = Task.new(
      title: "Test Title",
      content: "Test content",
      start_time: DateTime.now,
      end_time: DateTime.now + 1.hour,
      user: @user
    )
    expect(task).to be_valid
  end

  it "is not valid without a title" do
    task = Task.new(
      content: "Test content",
      start_time: DateTime.now,
      end_time: DateTime.now + 1.hour,
      user: @user
    )
    expect(task).to_not be_valid
  end

  it "is not valid if end_time is before start_time" do
    task = Task.new(
      title: "Test Title",
      content: "Test content",
      start_time: DateTime.now,
      end_time: DateTime.now - 1.hour,
      user: @user
    )
    expect(task).to_not be_valid
  end
end
