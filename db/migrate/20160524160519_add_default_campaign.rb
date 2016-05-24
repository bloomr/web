class AddDefaultCampaign < ActiveRecord::Migration
  def change
    Campaign.create(partner: 'default', price: '35')
  end
end
