class AddSourceToBloomy < ActiveRecord::Migration
  def change
    add_column :bloomies, :source, :string
  end
end
