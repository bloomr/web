class AddDoauthorizeToUser < ActiveRecord::Migration
  def change
    add_column :users, :do_authorize, :boolean, default: :false
  end
end
