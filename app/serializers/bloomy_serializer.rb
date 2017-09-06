class BloomySerializer < ActiveModel::Serializer
  attributes :id, :first_name, :email, :coached
  has_many :programs
end
