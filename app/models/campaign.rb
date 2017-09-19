class Campaign < ActiveRecord::Base
  has_many :campaignsProgramTemplates
  has_many :program_templates, through: :campaignsProgramTemplates

  accepts_nested_attributes_for :campaignsProgramTemplates, allow_destroy: true

  def self.find_by_partner_or_default(partner)
    campaign = Campaign.find_by_partner(partner)
    campaign.nil? ? Campaign.default : campaign
  end

  def amount(program_name)
    program_template = ProgramTemplate.find_by(name: program_name)
    campaign_pt = campaignsProgramTemplates.where(program_template: program_template).first

    to_return = if campaign_pt.present?
                  campaign_pt.price
                else
                  Campaign.default.campaignsProgramTemplates.where(program_template: program_template).first.price
                end

    (to_return * 100).to_i
  end

  def amount_to_display(program_name, format = '%0.02f')
    format(format, amount(program_name).to_f / 100)
  end

  def self.default
    Campaign.find_by_partner('default')
  end
end
