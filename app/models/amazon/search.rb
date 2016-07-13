require 'httparty'

module Amazon
  class Search
    def self.books(keywords, in_english)
      return [] if keywords.nil?
      query = Query.new(keywords, in_english)
      response = HTTParty.get(query.request_url)
      return [] if response.code != 200
      Response.new(response.body).books
    end
  end
end
