class AddPublishedToQuestionComments < ActiveRecord::Migration
  def change
    add_column :question_comments, :published, :boolean, :default => true
  end
end
