class CreateBloomyMissionJoinTable < ActiveRecord::Migration
  def change
    create_join_table :bloomies, :missions do |t|
      t.index [:bloomy_id, :mission_id], unique: true
      # t.index [:mission_id, :bloomy_id]
    end
  end
end
