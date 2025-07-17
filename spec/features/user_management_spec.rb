require "rails_helper"

RSpec.feature "user management", type: :feature do
  describe "user registration" do
    let(:user) { build(:user) }
    let(:user_with_blank_username) { build(:user, username: "") }
    let(:user_with_blank_email) { build(:user, email_address: "") }
    let(:user_with_blank_password) { build(:user, password: "", password_confirmation: "") }
    context "with valid credentials" do
      before do
        visit signup_path

        fill_in "user_username", with: user.username
        fill_in "user_email_address", with: user.email_address
        fill_in "user_password", with: user.password
        fill_in "user_password_confirmation", with: user.password
        click_button I18n.t("auth.sign_up")
      end
      it { expect(page).to have_content(I18n.t("flash.registration_successful")) }
    end

    context "with invalid credentials(blank username)" do
      before do
        visit signup_path

        fill_in "user_username", with: user_with_blank_username.username
        fill_in "user_email_address", with: user_with_blank_username.email_address
        fill_in "user_password", with: user_with_blank_username.password
        fill_in "user_password_confirmation", with: user_with_blank_username.password_confirmation
        click_button I18n.t("auth.sign_up")
      end
      it { expect(page).not_to have_content(I18n.t("flash.registration_unsuccessful")) }
    end

    context "with invalid credentials(blank email)" do
      before do
        visit signup_path

        fill_in "user_username", with: user_with_blank_email.username
        fill_in "user_email_address", with: user_with_blank_email.email_address
        fill_in "user_password", with: user_with_blank_email.password
        fill_in "user_password_confirmation", with: user_with_blank_email.password_confirmation
        click_button I18n.t("auth.sign_up")
      end
      it { expect(page).not_to have_content(I18n.t("flash.registration_unsuccessful")) }
    end

    context "with invalid credentials(blank password)" do
      before do
        visit signup_path

        fill_in "user_username", with: user_with_blank_password.username
        fill_in "user_email_address", with: user_with_blank_password.email_address
        fill_in "user_password", with: user_with_blank_password.password
        fill_in "user_password_confirmation", with: user_with_blank_password.password_confirmation
        click_button I18n.t("auth.sign_up")
      end
      it { expect(page).not_to have_content(I18n.t("flash.registration_unsuccessful")) }
    end

    context "with invalid credentials(password mismatch)" do
      before do
        visit signup_path

        fill_in "user_username", with: user.username
        fill_in "user_email_address", with: user.email_address
        fill_in "user_password", with: user.password
        fill_in "user_password_confirmation", with: "mismatch_password"
        click_button I18n.t("auth.sign_up")
      end
      it { expect(page).not_to have_content(I18n.t("flash.registration_unsuccessful")) }
    end
  end

  describe "user login" do
    let(:user) { create(:user) }
    context "with valid credentials" do
      before do
        visit login_path
        fill_in "email_address", with: user.email_address
        fill_in "password", with: user.password
        click_button I18n.t("auth.sign_in")
      end

      it { expect(page).to have_content(user.username) }
    end

    context "with invalid credentials" do
      before do
        visit login_path

        fill_in "email_address", with: user.email_address
        fill_in "password", with: "wrongpassword"
        click_button I18n.t("auth.sign_in")
      end

      it { expect(page).to have_content(I18n.t("auth.invalid_credentials")) }
    end
  end

  describe "user logout" do
    context "when logged in" do
      let(:user) { create(:user) }
      before do
        visit login_path
        fill_in "email_address", with: user.email_address
        fill_in "password", with: user.password
        click_button I18n.t("auth.sign_in")
      end

      it "logs the user out successfully" do
        click_button I18n.t("navbar.sign_out")
        expect(page).to have_current_path login_path(locale: I18n.locale)
      end
      it "logged out user should not see tasks page" do
        click_button I18n.t("navbar.sign_out")
        visit tasks_path
        expect(page).to have_current_path login_path(locale: I18n.locale)
      end
    end
  end
end
