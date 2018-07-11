class BundlesContract < ActiveRecord::Base
  belongs_to :bundle
  belongs_to :contract
end
