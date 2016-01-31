class Keyword < ActiveRecord::Base
  has_many :keyword_associations
  has_many :users, :through => :keyword_associations
  belongs_to :tribe

  def to_s
    return tag
  end

  def self.popular_keywords
    return self.joins(:keyword_associations)
               .select("distinct keywords.*, count(keyword_associations.id) as popularity")
               .group("keywords.id")
               .order("popularity DESC").limit(5)
  end
end
