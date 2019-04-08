require 'net/http'
require 'uri'
require 'json'

require 'radar/event'

module Radar
  class Reporter
    attr_reader :exception, :event, :api_url, :api_key

    def initialize(exception, env)
      @exception = exception
      @event = Event.new(exception, env)
      @api_url = Radar.configuration.api_url
      @api_key = Radar.configuration.api_key
    end

    def send
      uri = URI.parse("#{api_url}/api/v1/projects/#{api_key}/events")
      http = Net::HTTP.new(uri.host, uri.port)

      http.use_ssl = true if uri.scheme == 'https'

      header = { 'Content-Type': 'application/json' }
      request = Net::HTTP::Post.new(uri.request_uri, header)
      data = @event.event
      request.body = data.to_json
      begin
        http.request(request)
      rescue StandardError => error
        raise Radar::Error, error.message
      end
    end
  end
end
