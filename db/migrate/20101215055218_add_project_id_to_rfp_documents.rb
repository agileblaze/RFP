class AddProjectIdToRfpDocuments < ActiveRecord::Migration
  def self.up
    add_column :rfp_documents, :project_id, :integer
  end

  def self.down
    remove_column :rfp_documents, :project_id
  end
end
