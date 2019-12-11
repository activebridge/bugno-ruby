# frozen_string_literal: true

require 'bugno/handler'

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
          Handler.call(exception: e, env: env) if Bugno.configured?
          raise e
        end
      end
    end
  end
end
