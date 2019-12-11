# frozen_string_literal: true

require 'bugno/request_data_extractor'
require 'bugno/backtrace'
require 'bugno/encoding/encoding'
require 'rails' if defined?(Rails)

module Bugno
  class Event
    include RequestDataExtractor
    attr_reader :data

    def initialize(options = {})
      @env = options[:env]
      @job = options[:job]
      @exception = options[:exception]
      build_data
    end

    private

    def build_data
      @data = {
        title: truncate(@exception.class.inspect),
        message: truncate(@exception.message),
        server_data: server_data,
        created_at: Time.now.to_i,
        framework: Bugno.configuration.framework,
        environment: Bugno.configuration.environment
      }
      merge_extra_data
    end

    def merge_extra_data
      @data.merge!(backtrace: Backtrace.new(@exception.backtrace).parse_backtrace) if @exception.backtrace
      @data.merge!(extract_request_data_from_rack(@env)) if @env
      @data.merge!(background_data: @job) if @job
    end

    # TODO: move to utility module
    def truncate(string)
      string.is_a?(String) ? string[0...3000] : ''
    end

    # TODO: refactor
    def server_data
      data = { host: Socket.gethostname }
      data[:root] = Rails.root.to_s if defined?(Rails)
      data
    end
  end
end
