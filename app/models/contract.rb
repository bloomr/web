class Contract < ActiveRecord::Base
  has_many :bundles_contracts
  has_many :bundles, through: :bundles_contracts
end
