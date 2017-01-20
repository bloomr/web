class Program < ActiveRecord::Base
  has_and_belongs_to_many :bloomies
  has_and_belongs_to_many :missions
end
