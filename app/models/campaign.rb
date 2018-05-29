class Campaign < ActiveRecord::Base
  has_many :campaignsProgramTemplates
  has_many :program_templates, through: :campaignsProgramTemplates

  has_many :bundles_campaigns
  has_many :bundles, through: :bundles_campaigns

  accepts_nested_attributes_for :campaignsProgramTemplates, allow_destroy: true

  def self.find_by_partner_or_default(partner)
    campaign = Campaign.find_by_partner(partner)
    campaign.nil? ? Campaign.default : campaign
  end

  def amount(bundle_name)
    bundle = Bundle.find_by(name: bundle_name)
    bundle_campaign = bundles_campaigns.where(bundle: bundle).first

    to_return = if bundle_campaign.present?
                  bundle_campaign.price
                else
                  Campaign.default.bundles_campaigns.where(bundle: bundle).first.price
                end

    (to_return * 100).to_i
  end

  def amount_to_display(bundle_name, format = '%0.02f')
    format(format, amount(bundle_name).to_f / 100)
  end

  def self.default
    Campaign.find_by_partner('default')
  end
end
