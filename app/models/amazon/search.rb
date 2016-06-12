require 'httparty'
require 'nokogiri'

module Amazon
  class Search
    EXTRACT_MAP = {
      'title' => 'ItemAttributes/Title',
      'author' => 'ItemAttributes/Author',
      'isbn' => 'ItemAttributes/ISBN',
      'image_url' => 'MediumImage/URL'
    }.freeze

    def self.books(keywords)
      return [] if keywords.nil?
      query = Query.new(keywords)
      response = HTTParty.get(query.request_url)
      return [] if response.code != 200
      parse_response_body(response.body)
    end

    def self.parse_response_body(body)
      doc = Nokogiri::XML(body)
      doc.remove_namespaces!
      items = doc.xpath('/ItemSearchResponse/Items/Item')
      result = items.select { |i| valid?(i, EXTRACT_MAP.values) }.map do |item|
        hash = EXTRACT_MAP.reduce({}) do |h, el|
          h[el[0]] = item.xpath(el[1]).first.content
          h
        end
        Book.new(hash)
      end

      result.compact
    end

    def self.valid?(item, attributes)
      attributes.all? { |a| !item.xpath(a).first.nil? }
    end
  end
end
