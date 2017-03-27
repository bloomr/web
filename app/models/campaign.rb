class Campaign < ActiveRecord::Base
  def self.find_by_partner_or_default(partner)
    campaign = Campaign.find_by_partner(partner)
    campaign.nil? ? Campaign.default : campaign
  end

  def amount(program_name)
    to_return = case program_name
                when 'standard'
                  standard_price.nil? ? Campaign.default.standard_price : standard_price
                when 'premium'
                  premium_price.nil? ? Campaign.default.premium_price : premium_price
                end
    (to_return * 100).to_i
  end

  def amount_to_display(program_name)
    format('%0.02f', amount(program_name).to_f / 100)
  end

  def self.default
    Campaign.find_by_partner('default')
  end
end
