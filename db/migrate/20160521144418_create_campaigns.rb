class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :partner
      t.decimal :price
      t.string :campaign_url

      t.timestamps null: false
    end
  end
end
