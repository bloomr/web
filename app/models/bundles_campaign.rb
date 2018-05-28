class BundlesCampaign < ActiveRecord::Base
  belongs_to :bundle
  belongs_to :campaign
end
