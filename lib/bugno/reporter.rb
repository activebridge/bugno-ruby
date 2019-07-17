# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

module Bugno
  class Reporter
    attr_reader :uri, :http
    attr_accessor :request

    def initialize
      @uri = URI.parse("#{Bugno.configuration.api_url}/api/v1/projects/#{Bugno.configuration.api_key}/events")
      @http = Net::HTTP.new(uri.host, uri.port)
      @request = Net::HTTP::Post.new(uri.request_uri, 'Content-Type': 'application/json')
    end

    def send
      http.use_ssl = true if uri.scheme == 'https'

      response = http.request(request)
      Bugno.log_info(api_response(response))
    rescue StandardError => e
      Bugno.log_error(e.message)
    end

    def api_response(response)
      body = JSON.parse(response.body.presence || '{}')
      message = body['message'] || body['error'] || response.message
      "#{message.capitalize} | Code: #{response.code}"
    end
  end
end
