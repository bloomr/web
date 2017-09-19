class CampaignsProgramTemplate < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :program_template

  accepts_nested_attributes_for :program_template
end
