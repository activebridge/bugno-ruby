# frozen_string_literal: true

require 'bughub/reporter'

module Bughub
  module Middleware
    module Rails
      class BughubMiddleware
        def initialize(app)
          @app = app
        end

        def call(env)
          @app.call(env)
        rescue Error
          raise
        rescue Exception => e
          Thread.new { Reporter.new(e, env).send }
          raise e
        end
      end
    end
  end
end
