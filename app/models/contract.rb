class Contract < ActiveRecord::Base
  has_many :bundles_contracts
  has_many :bundles, through: :bundles_contracts

  accepts_nested_attributes_for :bundles_contracts, allow_destroy: true
end
