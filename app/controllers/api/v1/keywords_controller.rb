module Api
  module V1

    class KeywordsController < ApplicationController

      def index

        raw_sql = "select keywords.tag, count(keyword_associations.id) as popularity
        from keywords
        INNER JOIN keyword_associations on keywords.id = keyword_associations.keyword_id
        INNER JOIN users on users.id = keyword_associations.user_id and users.published = TRUE
        GROUP BY keywords.tag
        HAVING count(keyword_associations.id) > 0"

        keywords = ActiveRecord::Base.connection.execute(raw_sql)

        render json: keywords
      end

    end

  end
end


