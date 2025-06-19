require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index when authenticated" do
    # Simulate login by creating a session
    post session_path, params: { email_address: @user.email_address, password: "password" }
    get home_url
    assert_response :success
  end

  test "should redirect to login when not authenticated" do
    get home_url
    assert_response :redirect
    assert_redirected_to new_session_path
  end
end
