require 'time'
require 'uri'
require 'openssl'
require 'base64'

module Amazon
  class Query
    ENDPOINT = 'webservices.amazon.fr'.freeze
    REQUEST_URI = '/onca/xml'.freeze

    attr_accessor :request_url

    def initialize(keywords, in_english)
      params = build_params(keywords, in_english)
      query = build_query(params)
      signature = sign_query(query)
      @request_url = build_request_url(query, signature)
    end

    private

    def build_params(keywords, in_english)
      result = {
        'Service' => 'AWSECommerceService',
        'Operation' => 'ItemSearch',
        'AWSAccessKeyId' => ENV['AWS_PARTNER_ACCESS_KEY_ID'],
        'AssociateTag' => 'bloomr0b-21',
        'SearchIndex' => 'Books',
        'Keywords' => keywords,
        'ResponseGroup' => 'EditorialReview,Medium',
        'Sort' => 'salesrank',
        'Timestamp' => Time.now.gmtime.iso8601
      }
      result['SearchIndex'] = 'ForeignBooks' if in_english
      result
    end

    def build_query(params)
      params.sort.collect do |key, value|
        [URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")), URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))].join('=')
      end.join('&')
    end

    def sign_query(query)
      string_to_sign = "GET\n#{ENDPOINT}\n#{REQUEST_URI}\n#{query}"

      signed = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), ENV['AWS_PARTNER_SECRET_KEY'], string_to_sign)
      Base64.encode64(signed).strip
    end

    def build_request_url(query, signature)
      "http://#{ENDPOINT}#{REQUEST_URI}?#{query}&Signature=#{URI.escape(signature, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"
    end
  end
end
