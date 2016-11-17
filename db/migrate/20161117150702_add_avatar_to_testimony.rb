class AddAvatarToTestimony < ActiveRecord::Migration
  def up
    add_attachment :testimonies, :avatar
  end

  def down
    remove_attachment :testimonies, :avatar
  end
end
