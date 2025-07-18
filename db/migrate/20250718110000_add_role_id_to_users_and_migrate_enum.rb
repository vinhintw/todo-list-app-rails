class AddRoleIdToUsersAndMigrateEnum < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :role, null: true, foreign_key: true

    admin_role = Role.find_or_create_by!(name: Role::ADMIN) do |role|
      role.description = "Administrator"
    end
    user_role = Role.find_or_create_by!(name: Role::USER) do |role|
      role.description = "Normal user"
    end

    User.unscoped.find_each do |user|
      old_role_value = user.read_attribute(:role)

      if old_role_value == "admin"
        user.update_column(:role_id, admin_role.id)
      else
        user.update_column(:role_id, user_role.id)
      end
    end

    change_column_null :users, :role_id, false
    remove_column :users, :role, :integer
  end
end
