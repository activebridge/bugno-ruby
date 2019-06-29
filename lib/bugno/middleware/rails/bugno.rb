# frozen_string_literal: true

require 'bugno/reporter'

module Bugno
  module Middleware
    module Rails
      class BugnoMiddleware
        def initialize(app)
          @app = app
        end

        def call(env)
          @app.call(env)
        rescue Error
          raise
        rescue Exception => e
          Thread.new { Reporter.new(e, env).send } unless excluded_exception?(e)
          raise e
        end

        def excluded_exception?(exception)
          Bugno.configuration.exclude_rails_exceptions && \
            Bugno.configuration.excluded_exceptions.include?(exception.class.inspect)
        end
      end
    end
  end
end
