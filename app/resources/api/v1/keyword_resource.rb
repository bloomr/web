module Api
  module V1
    class KeywordResource < JSONAPI::Resource
      attributes :tag
      relationship :users, to: :many
    end
  end
end
