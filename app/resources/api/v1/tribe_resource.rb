module Api
  module V1
    class TribeResource < JSONAPI::Resource
      attributes :name, :description, :normalized_name
    end
  end
end
