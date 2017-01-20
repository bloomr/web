class ChangeBloomyProgramRelationToHasMany < ActiveRecord::Migration
  def change
    drop_table :bloomies_programs
    add_reference :programs, :bloomy, index: true
  end
end
