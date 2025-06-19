require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  def login_as(user)
    visit new_session_url
    fill_in "email_address", with: user.email_address
    fill_in "password", with: "password"
    click_on "Sign in"
  end
end
