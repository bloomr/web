class Tribe < ActiveRecord::Base
  has_many :user
  has_many :keywords
end
