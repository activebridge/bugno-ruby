# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'bugno/event'

module Bugno
  class Reporter
    attr_reader :exception, :event, :api_url, :api_key

    def initialize(exception, env)
      @exception = exception
      @event = Event.new(exception, env)
      @api_url = Bugno.configuration.api_url
      @api_key = Bugno.configuration.api_key
    end

    def send
      uri = URI.parse("#{api_url}/api/v1/projects/#{api_key}/events")
      http = Net::HTTP.new(uri.host, uri.port)

      http.use_ssl = true if uri.scheme == 'https'

      header = { 'Content-Type': 'application/json' }
      payload = Net::HTTP::Post.new(uri.request_uri, header)
      data = @event.event
      payload.body = data.to_json
      begin
        response = http.request(payload)
        Bugno.log_info(api_response(response))
      rescue StandardError => e
        Bugno.log_error("[Bugno] #{e.message}")
      end
    end

    def api_response(response)
      body = JSON.parse(response.body.presence || '{}')
      message = body['message'] || body['error'] || response.message
      "[Bugno]: #{message.capitalize} | Code: #{response.code}"
    end
  end
end
