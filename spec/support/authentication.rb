module Helpers
  module FeatureAuthentication
    def sign_in_as(user)
      visit login_path
      fill_in "email_address", with: user.email_address
      fill_in "password", with: user.password
      click_button I18n.t("auth.sign_in")
    end

    def sign_up_as(user)
      visit signup_path
      fill_in "user_username", with: user.username
      fill_in "user_email_address", with: user.email_address
      fill_in "user_password", with: user.password
      fill_in "user_password_confirmation", with: user.password_confirmation
      click_button I18n.t("auth.sign_up")
    end

    def sign_up_as_admin(user)
      visit new_dashboard_user_path
      fill_in "user_username", with: user.username
      fill_in "user_email_address", with: user.email_address
      fill_in "user_password", with: user.password
      fill_in "user_password_confirmation", with: user.password_confirmation
      select I18n.t("role.#{user.role}"), from: "user_role"
      click_button I18n.t("auth.sign_up")
    end
  end

  module RequestAuthentication
    def sign_in_as(user)
      post login_path, params: { email_address: user.email_address, password: user.password }
    end

    def sign_up_as(user)
      post signup_path, params: {
        username: user.username,
        email_address: user.email_address,
        password: user.password,
        password_confirmation: user.password_confirmation
      }
    end
  end
end
