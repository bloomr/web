class ProgramSerializer < ActiveModel::Serializer
  attributes [:name, :discourse, :intercom, :started_at, :ended_at]
  has_many :missions
end
