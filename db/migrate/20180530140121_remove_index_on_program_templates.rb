class RemoveIndexOnProgramTemplates < ActiveRecord::Migration
  def change
   remove_index :program_templates, :name
  end
end
