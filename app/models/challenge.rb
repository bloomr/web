class Challenge < ActiveRecord::Base
  has_many :challengesUsers
  has_many :users, through: :challengesUsers
end
