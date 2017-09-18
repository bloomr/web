class Program < ActiveRecord::Base
  belongs_to :bloomies
  has_and_belongs_to_many :missions
end
