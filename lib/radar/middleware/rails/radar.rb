require 'radar/reporter'

module Radar
  module Middleware
    module Rails
      class RadarMiddleware
        def initialize(app)
          @app = app
        end

        def call(env)
          @app.call(env)
        rescue Error
          raise
        rescue Exception => exception
          Thread.new { Reporter.new(exception, env).send }
          raise exception
        end
      end
    end
  end
end
