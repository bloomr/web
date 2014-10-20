class RemoveJobDescriptionFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :job_description, :text
  end
end
