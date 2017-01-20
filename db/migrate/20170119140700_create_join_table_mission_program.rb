class CreateJoinTableMissionProgram < ActiveRecord::Migration
  def change
    create_join_table :missions, :programs do |t|
      # t.index [:mission_id, :program_id]
      t.index [:program_id, :mission_id]
    end
  end
end
