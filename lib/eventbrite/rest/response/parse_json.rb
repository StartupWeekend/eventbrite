require_relative 'middleware'
require 'json'

module Eventbrite
  module REST
    module Response
      class ParseJson < Eventbrite::REST::Response::Middleware
        WHITESPACE_REGEX = /\A^\s*$\z/

        def parse(body)
          case body
          when WHITESPACE_REGEX, nil
            nil
          else
            JSON.parse(body, :symbolize_names => true)
          end
        end

        def on_complete(response)
          if parseable?(response)
            response.body = parse(response.body)
          end
        end

        def unparsable_status_codes
          [204, 301, 302, 304]
        end

        def parseable?(response)
          response.response_headers["Content-Type"] =~ /\bjson/ &&
            respond_to?(:parse) &&
            !unparsable_status_codes.include?(response.status)
        end
      end
    end
  end
end

Faraday::Response.register_middleware :parse_json => Eventbrite::REST::Response::ParseJson
