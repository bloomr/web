class BloomySerializer < ActiveModel::Serializer
  attributes :id, :first_name, :email
  has_many :missions
  has_many :programs
end
