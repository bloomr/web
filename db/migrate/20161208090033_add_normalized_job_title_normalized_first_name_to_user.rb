class AddNormalizedJobTitleNormalizedFirstNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :normalized_job_title, :string
    add_column :users, :normalized_first_name, :string
    add_index :users, [:normalized_job_title, :normalized_first_name], unique: true
  end
end
