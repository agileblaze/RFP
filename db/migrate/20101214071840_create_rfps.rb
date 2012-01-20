class CreateRfps < ActiveRecord::Migration
  def self.up
    create_table :rfps do |t|
      t.integer  :project_id
      t.string   :filename
      t.string   :content_type
      t.integer  :size
      #t.integer :assigned_to
      #t.integer :assigned_by
      t.integer  :created_by
      #t.string  :project_name
      t.text    :project_description
      #t.string  :rfp_doc_uploaded, :default => 'no'
      #t.date    :deadline
      t.timestamps
    end
  end

  def self.down
    drop_table :rfps
  end
end
