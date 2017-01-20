class ProgramSerializer < ActiveModel::Serializer
  attributes :name
  has_many :missions
end
