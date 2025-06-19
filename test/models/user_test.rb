require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      email_address: "test@example.com",
      username: "testuser",
      password: "password123"
    )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "username should be present" do
    @user.username = ""
    assert_not @user.valid?
  end

  test "username should be unique" do
    @user.save
    duplicate_user = @user.dup
    assert_not duplicate_user.valid?
  end

  test "username should be at least 3 characters" do
    @user.username = "ab"
    assert_not @user.valid?
  end

  test "email should be normalized" do
    @user.email_address = "  TeSt@ExAmPlE.CoM  "
    @user.save
    assert_equal "test@example.com", @user.email_address
  end

  test "default role should be normal" do
    @user.save
    assert @user.normal?
    assert_not @user.admin?
  end

  test "should have secure password" do
    assert @user.authenticate("password123")
    assert_not @user.authenticate("wrongpassword")
  end
end
