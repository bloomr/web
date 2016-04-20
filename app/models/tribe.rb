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

  private

  def normalize_name
    self.normalized_name = self.name.gsub('.','_')
  end
end
