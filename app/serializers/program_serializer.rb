class ProgramSerializer < ActiveModel::Serializer
  attributes [:name, :discourse, :intercom]
  has_many :missions
end
