class CreateStrengthUserJoinTable < ActiveRecord::Migration
  def change
    create_join_table :users, :strengths do |t|
      # t.index [:user_id, :strength_id]
      t.index [:strength_id, :user_id], unique: true
    end
  end
end
