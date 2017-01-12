class AddAuthenticationTokenToBloomy < ActiveRecord::Migration
  def change
    add_column :bloomies, :authentication_token, :string, limit: 30
    add_index :bloomies, :authentication_token, unique: true
  end
end
