class Keyword < ActiveRecord::Base
  before_save :normalize_tag

  has_many :keyword_associations
  has_many :users, through: :keyword_associations
  belongs_to :tribe

  scope :published, -> { joins(:users).where('users.published = ?', true) }

  def to_s
    tag
  end

  def self.popular_keywords
    joins(:keyword_associations)
      .select('distinct keywords.*, count(keyword_associations.id) as popularity')
      .group('keywords.id')
      .order('popularity DESC').limit(5)
  end

  private

  def normalize_tag
    self.normalized_tag = tag.nil? ? '' : ActiveSupport::Inflector.parameterize(tag)
  end
end
