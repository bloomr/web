class Campaign < ActiveRecord::Base
  def self.find_by_partner_or_default(partner)
    campaign = Campaign.find_by_partner(partner)
    return Campaign.find_by_partner('default') if campaign.nil?
    campaign
  end
end
