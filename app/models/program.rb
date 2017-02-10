class Program < ActiveRecord::Base
  belongs_to :bloomies
  has_and_belongs_to_many :missions

  def self.standard
    Program.new(name: 'standard', discourse: true, intercom: false)
  end
end
