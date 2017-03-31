class AddColumnNameToBloomy < ActiveRecord::Migration
  def change
    add_column :bloomies, :name, :string
  end
end
