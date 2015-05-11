class AddQuestionComments < ActiveRecord::Migration
  def up
    create_table :question_comments do |t|
      t.string :author_avatar_url
      t.string :author_name, null: false
      t.text :comment, null: false

      t.references :question, index:true
    end
  end

  def down
    drop_table :question_comments
  end
end
