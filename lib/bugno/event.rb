# frozen_string_literal: true

require 'bugno/request_data_extractor'
require 'bugno/backtrace'
require 'bugno/encoding/encoding'
require 'rails'

module Bugno
  class Event
    include RequestDataExtractor
    attr_reader :data

    def initialize(exception, env)
      @data = build_data(exception, env)
    end

    private

    def build_data(exception, env)
      @data = {
        title: exception.class.inspect,
        message: exception.message,
        server_data: server_data,
        backtrace: Backtrace.new(exception.backtrace).parse_backtrace
      }
      @data.merge!(configuration_data)
      @data.merge!(extract_request_data_from_rack(env))
    end

    def server_data
      { host: Socket.gethostname,
        root: Rails.root.to_s }
    end

    def configuration_data
      { framework: Bugno.configuration.framework,
        environment: Bugno.configuration.environment }
    end
  end
end
