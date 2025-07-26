require "rails_helper"

RSpec.feature "role management", type: :feature do
  describe "admin role management" do
    let(:admin) { create(:user, :admin) }
    let(:user) { create(:user, :user) }
    let(:role_name) { "thirdrole" }
    context "when admin is logged in & creates a new role with valid attributes" do
      before do
        sign_in_as(admin)
        visit admin_create_role_path
        fill_in "role_name", with: role_name
        click_button I18n.t("create")
      end
      it { expect(page).to have_content(I18n.t("role.created", name: role_name)) }
    end

    context "when admin is logged in & tries to create a new role with invalid attributes" do
      before do
        sign_in_as(admin)
        visit admin_create_role_path
        fill_in "role_name", with: ""
        click_button I18n.t("create")
      end
      it { expect(page).to have_content(I18n.t("activerecord.errors.messages.blank")) }
    end

    context "when admin is logged in & tries to create a role that already exists" do
      before do
        Role.find_or_create_by!(name: "admin")
        sign_in_as(admin)
        visit admin_create_role_path
        fill_in "role_name", with: "admin"
        click_button I18n.t("create")
      end
      it { expect(page).to have_content(I18n.t("activerecord.errors.messages.taken")) }
    end
  end
end
