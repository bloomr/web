class Tribe < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :keywords
  before_save :normalize_name

  private

  def normalize_name
    self.normalized_name = self.name.gsub('.','_')
  end
end
