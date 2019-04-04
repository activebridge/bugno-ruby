require 'radar/reporter'

module Radar
  module Middleware
    module Rails
      class RadarMiddleware
        def initialize(app)
          @app = app
        end

        def call(env)
          _, headers, body = response = @app.call(env)

          if headers['X-Cascade'] == 'pass'
            body.close if body.respond_to?(:close)
            raise ActionController::RoutingError, "No route matches [#{env['REQUEST_METHOD']}] #{env['PATH_INFO'].inspect}"
          end

          response
        rescue Exception => exception
          Reporter.new(exception).send
        end
      end
    end
  end
end
