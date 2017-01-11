class Mission < ActiveRecord::Base
  has_and_belongs_to_many :bloomies
end
