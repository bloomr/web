class AddCguAcceptedColomunToBloomies < ActiveRecord::Migration
  def change
    add_column :bloomies, :cgu_accepted, :bool
  end
end
