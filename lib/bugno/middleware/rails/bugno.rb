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
        rescue Exception => e
          Handler.new(e, env: env).handle_exception if Bugno.configured?
          raise e
        end
      end
    end
  end
end
