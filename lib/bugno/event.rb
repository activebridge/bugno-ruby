# frozen_string_literal: true

require 'bugno/request_data_extractor'
require 'bugno/backtrace'
require 'bugno/encoding/encoding'
require 'rails'

module Bugno
  class Event
    include RequestDataExtractor
    attr_reader :data

    def initialize(exception, env: nil, job: nil)
      @env = env
      @job = job
      @exception = exception
      build_data
    end

    private

    def build_data
      @data = {
        title: truncate(@exception.class.inspect),
        message: truncate(@exception.message),
        server_data: server_data,
        backtrace: Backtrace.new(@exception.backtrace).parse_backtrace,
        created_at: Time.now.to_i,
        framework: Bugno.configuration.framework,
        environment: Bugno.configuration.environment
      }
      merge_extra_data
    end

    def merge_extra_data
      @data.merge!(extract_request_data_from_rack(@env)) if @env
      @data.merge!(background_data: @job) if @job
    end

    # TODO: move to utility module
    def truncate(string)
      string.is_a?(String) ? string[0...3000] : ''
    end

    # TODO: should be added as integration
    def server_data
      { host: Socket.gethostname,
        root: Rails.root.to_s }
    end
  end
end
