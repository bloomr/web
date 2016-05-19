class AddFirstNameAndAgeToBloomy < ActiveRecord::Migration
  def change
    add_column :bloomies, :first_name, :string
    add_column :bloomies, :age, :integer
  end
end
