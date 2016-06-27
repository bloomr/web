class Tribe < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :keywords
  before_save :normalize_name

  def last_month_view_count
    user_ids = self.users.pluck(:id)
    Impression
      .where(impressionable_type:'User', impressionable_id: user_ids,
            created_at: Date.today.beginning_of_month.last_month..Date.today.beginning_of_month)
      .select(:impressionable_id, :request_hash)
      .distinct
      .count(:impressionable_id, :request_hash)
  end

  def top_keywords
    result = Keyword
             .joins('join keyword_associations on keyword_associations.keyword_id = keywords.id')
             .joins('join users on users.id = keyword_associations.user_id')
             .joins('join tribes_users on tribes_users.user_id = keyword_associations.user_id')
             .order('count_all desc')
             .group('keywords.id')
             .where("tribes_users.tribe_id = #{id}")
             .count

    keyword_ids = result.take(3).map{ |e| e[0].to_i }
    Keyword.where(id: keyword_ids)
  end

  private

  def normalize_name
    self.normalized_name = self.name.gsub('.','_')
  end
end
