class AddCoachedToBloomy < ActiveRecord::Migration
  def change
    add_column :bloomies, :coached, :boolean, default: false
  end
end
