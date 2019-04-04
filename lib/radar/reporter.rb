require 'uri'
require 'net/http'

require 'radar/event'

module Radar
  class Reporter
    attr_reader :exception, :event

    def initialize(exception)
      @exception = exception
      @event = Event.new(exception)
    end

    def send
      uri = URI('http://localhost:3000/api/v1/projects')
      request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
      request.body = @event.data.to_json
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end
    end
  end
end
