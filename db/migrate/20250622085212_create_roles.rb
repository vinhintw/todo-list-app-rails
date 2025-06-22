class CreateRoles < ActiveRecord::Migration[8.0]
  def up
    create_table :roles do |t|
      t.string :name, null: false
      t.text :description, null: false

      t.timestamps
    end

    add_index :roles, :name, unique: true

    # Create default roles
    Role.find_or_create_by(name: 'admin') do |role|
      role.description = 'Full system access with all administrative privileges'
    end

    Role.find_or_create_by(name: 'user') do |role|
      role.description = 'Standard user with basic access to personal tasks'
    end

    Role.find_or_create_by(name: 'moderator') do |role|
      role.description = 'Enhanced user with limited administrative privileges'
    end
  end

  def down
    drop_table :roles
  end
end
