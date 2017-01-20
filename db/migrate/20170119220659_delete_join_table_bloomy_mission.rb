class DeleteJoinTableBloomyMission < ActiveRecord::Migration
  def change
    drop_table :bloomies_missions
  end
end
