class Campaign < ActiveRecord::Base
  def self.find_by_partner_or_default(partner)
    campaign = Campaign.find_by_partner(partner)
    campaign.nil? ? Campaign.default : campaign
  end

  def amount(program)
    to_return = case program
                when 'standard'
                  standard_price.nil? ? Campaign.default.standard_price : standard_price
                when 'premium'
                  premium_price.nil? ? Campaign.default.premium_price : premium_price
                end
    to_return * 100
  end

  def self.default
    Campaign.find_by_partner('default')
  end
end
