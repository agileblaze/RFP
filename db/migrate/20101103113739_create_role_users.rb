class CreateRoleUsers < ActiveRecord::Migration
  def self.up
    create_table :role_users do |t|
      t.column :role_id, :integer
      t.column :user_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :role_users
  end
end
