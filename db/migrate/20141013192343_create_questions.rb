class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.string :answer
      t.string :identifier

      t.timestamps

      t.references :user, index:true
    end

    add_index :questions, :identifier
  end
end