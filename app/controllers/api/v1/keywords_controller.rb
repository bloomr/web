module Api
  module V1
    class KeywordsController < BaseController
      def top
        raw_sql = "select keywords.tag, count(keyword_associations.id) as popularity
        from keywords
        INNER JOIN keyword_associations on keywords.id = keyword_associations.keyword_id
        INNER JOIN users on users.id = keyword_associations.user_id and users.published = TRUE
        GROUP BY keywords.tag
        HAVING count(keyword_associations.id) > 0"

        keywords = ActiveRecord::Base.connection.execute(raw_sql)
        render json: keywords
      end

      def index
        published_keywords = Keyword.published

        keywords_ressources = published_keywords.map { |k| Api::V1::KeywordResource.new(k, nil) }
        render json: JSONAPI::ResourceSerializer
          .new(Api::V1::KeywordResource)
          .serialize_to_hash(keywords_ressources)
          .to_json
      end
    end
  end
end
