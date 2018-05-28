class CreateCampaignBundleJoinTable < ActiveRecord::Migration
  def change
    create_table 'bundles_campaigns' do |t|
      t.integer :bundle_id
      t.integer :campaign_id
      t.decimal 'price', null: false
      t.index [:bundle_id, :campaign_id], unique: true
    end
  end
end
