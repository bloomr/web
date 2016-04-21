class AddIndexOnChallengesUsers < ActiveRecord::Migration
  def change
      add_index :challenges_users, [:user_id, :challenge_id], unique: true
  end
end
