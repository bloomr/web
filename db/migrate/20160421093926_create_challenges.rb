class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :challenges_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :challenge, index: true
      t.timestamps null: false
    end
  end
end
