require 'radar/request_data_extractor'
require 'radar/backtrace'
require 'rails'

module Radar
  class Event
    include RequestDataExtractor
    attr_reader :event

    def initialize(exception, env)
      @event = build_event(exception, env)
    end

    def server_data
      @server_data ||= {
        host: Socket.gethostname,
        root: Rails.root.to_s
      }
      end

    def build_event(exception, env)
      @event = {
        timestamp: Time.now.to_i,
        title: exception.class.inspect,
        message: exception.message,
        server_data: server_data,
        backtrace: Backtrace.new(exception.backtrace).parse_backtrace
      }
      @event.merge!(Radar.configuration.get)
      @event.merge!(extract_request_data_from_rack(env))
    end
  end
end
