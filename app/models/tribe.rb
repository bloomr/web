class Tribe < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :keywords
  before_save :normalize_name

  def last_month_view_count
    user_ids = self.users.pluck(:id)
    sql = <<-EOF
select count(*) from
  (select distinct impressionable_id, session_hash from impressions
  where impressionable_type='User'
  AND created_at >= '#{Date.today.beginning_of_month.last_month}'
  AND created_at <= '#{Date.today.beginning_of_month}'
  AND impressionable_id in ( #{user_ids.join(',')} )
  group by impressionable_id, session_hash) as temp1;
    EOF

    ActiveRecord::Base.connection.select_value(sql).to_i
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

  def next
    Tribe.where('id > ?', id).order('id ASC').first || Tribe.first
  end

  def previous
    Tribe.where('id < ?', id).order('id DESC').first || Tribe.last
  end

  private

  def normalize_name
    self.normalized_name = ActiveSupport::Inflector.parameterize(name)
  end
end
