# Use this hook to configure impressionist parameters
#Impressionist.setup do |config|
  # Define ORM. Could be :active_record (default), :mongo_mapper or :mongoid
  # config.orm = :active_record
#end


class Impression < ActiveRecord::Base

  def self.last_month_count
    self
    .where('created_at >= ?', Date.today.beginning_of_month.last_month)
    .where('created_at <= ?', Date.today.end_of_month.last_month)
    .group(:session_hash)
    .count.length
  end

end
