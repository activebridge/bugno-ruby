module Radar
  module Middleware
    module Rails
      class RadarMiddleware

        def initialize(app)
          @app = app
        end

        def call(env)
          response = @app.call(env)
          rescue Exception => exception
        end
      end
    end
  end
end
