class KeywordAssociation < ActiveRecord::Base
  belongs_to :user
  belongs_to :keyword

  def keyword_popular?
    KeywordAssociation.where(keyword: keyword).count >= 2
  end
end
