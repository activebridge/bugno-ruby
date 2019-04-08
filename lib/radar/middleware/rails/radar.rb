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
          Reporter.new(exception, env).send
          raise
        end
      end
    end
  end
end
