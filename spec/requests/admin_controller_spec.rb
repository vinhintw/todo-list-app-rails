require "rails_helper"

RSpec.describe "AdminController", type: :request do
  let!(:admin) { create(:user, :admin) }
  let!(:user) { create(:user, :normal) }
  let!(:other_admin) { create(:user, :admin) }

  describe "GET #index" do
    context "when admin is logged in" do
      before do
        sign_in_as(admin)
        get dashboard_root_path
      end

      it { expect(response.body).to include(admin.username) }
      it { expect(response.body).to include(user.username) }


      it { expect(response.body).to include("#{User.where(role: "admin").count}") }
      it { expect(response.body).to include("#{User.where(role: "normal").count}") }
    end

    context "when not admin" do
      before do
        sign_in_as(user)
        get dashboard_root_path
      end

      it { expect(response).to redirect_to(root_path) }
    end
  end

  describe "POST #create" do
    before { sign_in_as(admin) }

    context "with valid params" do
      let(:params) do
        { user: { username: "newuser", email_address: "new@example.com", password: "password123", password_confirmation: "password123" } }
      end

      it "creates a new user" do
        expect {
          post dashboard_users_path, params: params
        }.to change(User, :count).by(1)
        expect(response).to redirect_to(dashboard_root_path)
        follow_redirect!
        expect(response.body).to include(I18n.t("flash.registration_successful"))
      end
    end

    context "with invalid params" do
      let(:params) do
        { user: { username: "", email_address: "", password: "", password_confirmation: "" } }
      end

      it "does not create user" do
        expect {
          post dashboard_users_path, params: params
        }.not_to change(User, :count)
        expect(response.body).to include(I18n.t("auth.prohibited_from_being_saved"))
      end
    end
  end

  describe "PATCH #update" do
    before { sign_in_as(admin) }
    let(:target_user) { create(:user) }

    context "with valid params" do
      it "updates user info" do
        patch dashboard_user_path(target_user), params: { user: { username: "updated" } }
        expect(target_user.reload.username).to eq("updated")
        expect(response).to redirect_to(dashboard_root_path)
      end
    end

    context "with invalid params" do
      it "does not update user" do
        patch dashboard_user_path(target_user), params: { user: { username: "" } }
        expect(target_user.reload.username).not_to eq("")
        expect(response.body).to include(I18n.t("auth.prohibited_from_being_saved"))
      end
    end

    context "with blank password" do
      it "does not change password" do
        old_encrypted = target_user.encrypted_password
        patch dashboard_user_path(target_user), params: { user: { password: "", password_confirmation: "" } }
        expect(target_user.reload.encrypted_password).to eq(old_encrypted)
      end
    end
  end

  describe "DELETE #destroy" do
    before { sign_in_as(admin) }
    let!(:target_user) { create(:user) }

    it "deletes user and redirects" do
      expect {
        delete dashboard_user_path(target_user)
      }.to change(User, :count).by(-1)
      expect(response).to redirect_to(dashboard_root_path)
      follow_redirect!
      expect(response.body).to include(I18n.t("flash.user_destroyed"))
    end
  end

  describe "GET #user_tasks" do
    before { sign_in_as(admin) }
    let!(:target_user) { create(:user) }
    let!(:tasks) { create_list(:task, 20, user: target_user) }
    it "shows paginated tasks and total count" do
      get tasks_dashboard_user_path(target_user)
      expect(response.body).to include(tasks.last.title)
      expect(response.body).to include("#{target_user.tasks.count}")
    end
  end

  describe "admin route security" do
    it "blocks non-admin access to admin actions" do
      sign_in_as(user)
      get dashboard_root_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "role management security" do
    before { sign_in_as(admin) }

    it "allows admin to promote normal user to admin" do
      patch dashboard_user_path(user), params: { user: { role: "admin" } }
      expect(user.reload.role).to eq("admin")
    end

    it "allows admin to demote other admin to normal" do
      patch dashboard_user_path(other_admin), params: { user: { role: "normal" } }
      expect(other_admin.reload.role).to eq("normal")
    end

    it "does not allow admin to demote themselves" do
      patch dashboard_user_path(admin), params: { user: { role: "normal" } }
      expect(admin.reload.role).to eq("admin")
      expect(response.body).to include(I18n.t("flash.user_cannot_demote"))
    end

    it "does not allow admin to delete last admin(self)" do
      delete dashboard_user_path(other_admin)
      expect(response).to redirect_to(dashboard_root_path)
      follow_redirect!
      expect(response.body).to include(I18n.t("flash.user_destroyed"))

      delete dashboard_user_path(admin)
      expect(response).to redirect_to(dashboard_root_path)
      follow_redirect!
      expect(response.body).to include(I18n.t("flash.cannot_delete_self"))
    end
  end
end
