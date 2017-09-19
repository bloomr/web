class SeedCampagnProgramJoinTable < ActiveRecord::Migration
  def up
    standard_pt = ProgramTemplate.find_by name: 'standard'
    premium_pt = ProgramTemplate.find_by name: 'premium'

    Campaign.all.each do |campaign|
      if campaign.standard_price.present?
        CampaignsProgramTemplate.create(campaign: campaign, program_template: standard_pt, price: campaign.standard_price)
      end

      if campaign.premium_price.present?
        CampaignsProgramTemplate.create(campaign: campaign, program_template: premium_pt, price: campaign.premium_price)
      end
    end
  end
end
