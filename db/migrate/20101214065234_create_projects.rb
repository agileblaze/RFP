class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string  :project_name
      t.integer :assigned_to
      t.integer :assigned_by
      t.integer :created_by
      t.string  :rfp_doc_uploaded, :default => 'no'
      t.date    :deadline
      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
