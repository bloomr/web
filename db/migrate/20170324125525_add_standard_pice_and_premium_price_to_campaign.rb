class AddStandardPiceAndPremiumPriceToCampaign < ActiveRecord::Migration
  def change
    rename_column :campaigns, :price, :standard_price
    add_column :campaigns, :premium_price, :decimal
  end
end
