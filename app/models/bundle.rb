class Bundle < ActiveRecord::Base
  has_many :program_templates

  has_many :bundles_campaigns
  has_many :campaigns, through: :bundles_campaigns

  accepts_nested_attributes_for :program_templates, allow_destroy: true

  def to_program
    program_templates.map(&:to_program)
  end
end
