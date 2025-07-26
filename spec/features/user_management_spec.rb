require "rails_helper"

RSpec.feature "user management", type: :feature do
  describe "user registration" do
    let(:user) { build(:user) }
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

        fill_in "user_username", with: ""
        fill_in "user_email_address", with: user.email_address
        fill_in "user_password", with: user.password
        fill_in "user_password_confirmation", with: user.password_confirmation
        click_button I18n.t("auth.sign_up")
      end
      it { expect(page).not_to have_content(I18n.t("flash.registration_unsuccessful")) }
    end

    context "with invalid credentials(blank email)" do
      before do
        visit signup_path

        fill_in "user_username", with: user.username
        fill_in "user_email_address", with: ""
        fill_in "user_password", with: user.password
        fill_in "user_password_confirmation", with: user.password_confirmation
        click_button I18n.t("auth.sign_up")
      end
      it { expect(page).not_to have_content(I18n.t("flash.registration_unsuccessful")) }
    end

    context "with invalid credentials(blank password)" do
      before do
        visit signup_path

        fill_in "user_username", with: user.username
        fill_in "user_email_address", with: user.email_address
        fill_in "user_password", with: ""
        fill_in "user_password_confirmation", with: ""
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
        sign_in_as(user)
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
        sign_in_as(user)
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

  describe "admin dashboard" do
    let(:admin) { create(:user, :admin) }
    let(:user) { create(:user) }

    context "when admin is logged in can access admin dashboard" do
      before do
          sign_in_as(admin)
          visit admin_path
        end

        it { expect(page).to have_content(I18n.t("admin.dashboard.user_management")) }
        it { expect(page).to have_content(I18n.t("admin.dashboard.admin_title")) }
    end

    context "when normal user is logged in can not access admin dashboard" do
      before do
        sign_in_as(user)
        visit admin_path
      end

      it { expect(page).not_to have_content(I18n.t("admin.dashboard.user_management")) }
      it { expect(page).to have_current_path root_path(locale: I18n.locale) }
    end
  end

  describe "admin user management" do
    let!(:admin) { create(:user, :admin) }
    let!(:user) { create(:user) }
    let(:new_user) { build(:user, username: "newuser", email_address: "newuser@example.com", password: "password123", password_confirmation: "password123") }
    let(:invalid_user) { build(:user, username: "a", email_address: user.email_address, password: "password123", password_confirmation: "mismatch123") }
    context "when admin created a user with valid credentials" do
      before do
        sign_in_as(admin)
        visit admin_path
        sign_up_as_admin(new_user)
      end

      it { expect(page).to have_content(I18n.t("flash.registration_successful")) }
      it { expect(page).to have_content(new_user.username) }
    end

    context "when admin created a user with invalid credentials" do
      before do
        sign_in_as(admin)
        visit admin_path
        sign_up_as_admin(invalid_user)
      end

      it { expect(page).to have_content(I18n.t("auth.prohibited_from_being_saved")) }
      it { expect(page).to have_content(I18n.t("activerecord.errors.messages.too_short", count: 3)) }
      it { expect(page).to have_content(I18n.t("activerecord.errors.messages.taken")) }
      it { expect(page).to have_content(I18n.t("activerecord.errors.messages.confirmation")) }
    end

    context "when admin is logged in & tries to delete self" do
      before do
        sign_in_as(admin)
        visit admin_path(locale: I18n.locale, id: admin.id)
        within("tr", text: admin.username) do
          click_button I18n.t("delete")
        end
      end
      it { expect(page).to have_content(I18n.t("flash.cannot_delete_self")) }
    end
  end
end
