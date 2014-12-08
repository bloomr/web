class AddPublishedFlagToUser < ActiveRecord::Migration
  def change
    add_column :users, :published, :boolean, :default => false

    User.update_all(:published => true)
  end
end
