require 'nokogiri'

module Amazon
  class Response
    attr_accessor :books

    EXTRACT_MAP = {
      'title' => 'ItemAttributes/Title',
      'author' => 'ItemAttributes/Author',
      'isbn' => 'ItemAttributes/ISBN',
      'image_url' => 'MediumImage/URL'
    }.freeze

    def initialize(body)
      doc = Nokogiri::XML(body)
      doc.remove_namespaces!
      items = doc.xpath('/ItemSearchResponse/Items/Item')
      @books = items.select { |i| valid?(i, EXTRACT_MAP.values) }.map do |item|
        hash = EXTRACT_MAP.reduce({}) do |h, el|
          h[el[0]] = item.xpath(el[1]).first.content
          h
        end
        Book.new(hash)
      end
    end

    private

    def valid?(item, attributes)
      attributes.all? { |a| !item.xpath(a).first.nil? }
    end
  end
end
