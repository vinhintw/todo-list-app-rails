require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should redirect to tasks when authenticated" do
    # Simulate login by creating a session
    post session_path, params: { email_address: @user.email_address, password: "password" }
    get home_url
    assert_response :redirect
    assert_redirected_to tasks_path
  end

  test "should get index when not authenticated" do
    get home_url
    assert_response :success
  end
end
