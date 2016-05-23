class Campaign < ActiveRecord::Base
  def self.find_by_partner_or_default(partner)
    campaign = Campaign.find_by_partner(partner)
    if campaign.nil? then return Campaign.find_by_partner('default')
    else return campaign end
  end
end
