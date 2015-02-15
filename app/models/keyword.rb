class Keyword < ActiveRecord::Base
  has_many :keyword_associations
  has_many :users, :through => :keyword_associations

  def to_s
    return tag
  end
end
