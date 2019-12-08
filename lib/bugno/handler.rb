# frozen_string_literal: true

require 'bugno/event'
require 'bugno/reporter'

module Bugno
  class Handler
    attr_reader :event, :reporter, :exception, :env, :job

    def initialize(options = {})
      @exception = options[:exception]
      @event = Event.new(exception: options[:exception], env: options[:env], job: options[:job])
      @reporter = Reporter.new
    end

    def self.call(options = {})
      self.new(options).handle_exception
    end

    def handle_exception
      return if excluded_exception? || !usage_environment?

      @reporter.request.body = @event.data.to_json
      Bugno.configuration.send_in_background ? Thread.new { @reporter.send } : @reporter.send
    end

    private

    def excluded_exception?
      Bugno.configuration.exclude_rails_exceptions && \
        Bugno.configuration.excluded_exceptions.include?(@exception.class.inspect)
    end

    def usage_environment?
      Bugno.configuration.usage_environments.include?(Bugno.configuration.environment)
    end
  end
end
