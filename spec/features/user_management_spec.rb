require "rails_helper"

RSpec.feature "user management", type: :feature do
  describe "user registration" do
    context "with valid credentials" do
      before do
        visit signup_path

        fill_in "user_username", with: "testuser"
        fill_in "user_email_address", with: "test@example.com"
        fill_in "user_password", with: "password123"
        fill_in "user_password_confirmation", with: "password123"
        click_button I18n.t("auth.sign_up")
      end
      it { expect(page).to have_content(I18n.t("flash.registration_successful")) }
    end

    context "with invalid credentials" do
      before do
        visit signup_path

        fill_in "user_username", with: "testuser"
        fill_in "user_email_address", with: "test@example.com"
        fill_in "user_password", with: "password123"
        fill_in "user_password_confirmation", with: "password123"
        click_button I18n.t("auth.sign_up")
      end
      it { expect(page).to have_content(I18n.t("flash.registration_successful")) }
    end

    context "with invalid credentials(blank username)" do
      before do
        visit signup_path

        fill_in "user_username", with: ""
        fill_in "user_email_address", with: "test@example.com"
        fill_in "user_password", with: "password123"
        fill_in "user_password_confirmation", with: "password123"
        click_button I18n.t("auth.sign_up")
      end
      it { expect(page).not_to have_content(I18n.t("flash.registration_unsuccessful")) }
    end

    context "with invalid credentials(blank email)" do
      before do
        visit signup_path

        fill_in "user_username", with: "testuser"
        fill_in "user_email_address", with: ""
        fill_in "user_password", with: "password123"
        fill_in "user_password_confirmation", with: "password123"
        click_button I18n.t("auth.sign_up")
      end
      it { expect(page).not_to have_content(I18n.t("flash.registration_unsuccessful")) }
    end

    context "with invalid credentials(blank password)" do
      before do
        visit signup_path

        fill_in "user_username", with: "testuser"
        fill_in "user_email_address", with: "test@example.com"
        fill_in "user_password", with: ""
        fill_in "user_password_confirmation", with: ""
        click_button I18n.t("auth.sign_up")
      end
      it { expect(page).not_to have_content(I18n.t("flash.registration_unsuccessful")) }
    end

    context "with invalid credentials(password mismatch)" do
      before do
        visit signup_path

        fill_in "user_username", with: "testuser"
        fill_in "user_email_address", with: "test@example.com"
        fill_in "user_password", with: "password123"
        fill_in "user_password_confirmation", with: "password456"
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
