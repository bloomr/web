class AddCompanyNameToBloomy < ActiveRecord::Migration
  def change
    add_column :bloomies, :company_name, :string
  end
end
