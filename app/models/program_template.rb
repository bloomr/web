class ProgramTemplate < ActiveRecord::Base
  def to_program
    Program.new(slice(:name, :discourse, :intercom))
  end
end
