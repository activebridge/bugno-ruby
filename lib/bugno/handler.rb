# frozen_string_literal: true

require 'bugno/event'
require 'bugno/reporter'

module Bugno
  class Handler
    attr_reader :event, :reporter, :exception, :env, :job

    def initialize(exception, env: nil, job: nil)
      @exception = exception
      @event = Event.new(exception, env: env, job: job)
      @reporter = Reporter.new
    end

    def handle_exception
      return if excluded_exception? || !usage_environment?

      reporter.request.body = event.data.to_json
      Bugno.configuration.send_in_background ? Thread.new { reporter.send } : reporter.send
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
