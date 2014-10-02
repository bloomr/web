class AddJobAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :job_title, :string
    add_column :users, :job_description, :text
  end
end
