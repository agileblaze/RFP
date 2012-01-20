class CreateRolesUsers < ActiveRecord::Migration
  def self.up
    create_table :roles_users do |t|
      t.column :role_id, :integer
      t.column :user_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :roles_users
  end
end
