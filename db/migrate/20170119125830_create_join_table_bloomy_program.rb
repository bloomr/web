class CreateJoinTableBloomyProgram < ActiveRecord::Migration
  def change
    create_join_table :bloomies, :programs do |t|
      t.index [:bloomy_id, :program_id]
      # t.index [:program_id, :bloomy_id]
    end
  end
end
