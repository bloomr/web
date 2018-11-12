class BloomySerializer < ActiveModel::Serializer
  attributes :id, :first_name, :name, :email, :coached, :company_name, :age
  has_many :programs
end
