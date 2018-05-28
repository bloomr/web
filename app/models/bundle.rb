class Bundle < ActiveRecord::Base
  has_many :program_templates

  accepts_nested_attributes_for :program_templates, allow_destroy: true
end
