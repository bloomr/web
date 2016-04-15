class AddNormalizedNameToTribe < ActiveRecord::Migration
  def change
    add_column :tribes, :normalized_name, :string
  end
end
