module Api
  module V1
    class StrengthResource < JSONAPI::Resource
      immutable
      attributes :name
    end
  end
end
