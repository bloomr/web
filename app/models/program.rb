class Program < ActiveRecord::Base
  belongs_to :bloomies
  has_and_belongs_to_many :missions

  def self.standard
    Program.new(name: 'standard', discourse: true, intercom: false)
  end

  def self.premium
    Program.new(name: 'premium', discourse: true, intercom: true)
  end

  def self.from_name(name)
    case name
    when 'standard'
      Program.standard
    when 'premium'
      Program.premium
    end
  end
end
