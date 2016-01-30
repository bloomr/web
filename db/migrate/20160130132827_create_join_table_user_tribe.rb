class CreateJoinTableUserTribe < ActiveRecord::Migration
  def change
    create_join_table :users, :tribes do |t|
      t.index [:tribe_id, :user_id]
    end
  end
end
