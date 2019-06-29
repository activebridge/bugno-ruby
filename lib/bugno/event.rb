# frozen_string_literal: true

require 'bugno/request_data_extractor'
require 'bugno/backtrace'
require 'bugno/encoding/encoding'
require 'rails'

module Bugno
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
      @event.merge!(configuration_data)
      @event.merge!(extract_request_data_from_rack(env))
    end

    def configuration_data
      { framework: Bugno.configuration.framework,
        environment: Bugno.configuration.environment }
    end
  end
end
