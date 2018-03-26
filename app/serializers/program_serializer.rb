class ProgramSerializer < ActiveModel::Serializer
  attributes [:name, :discourse, :intercom, :ended_at]
  has_many :missions
end
