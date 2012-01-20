class CreateRfpDocuments < ActiveRecord::Migration
  def self.up
    create_table :rfp_documents do |t|
      #t.integer :rfp_id
      t.integer :project_id
      t.integer :uploded_by
      t.string  :filename
      t.string  :content_type
      t.integer :size
      t.string  :status
      t.text    :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :rfp_documents
  end
end
