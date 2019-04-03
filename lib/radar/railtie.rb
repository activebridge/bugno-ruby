require 'rails/railtie'
module Radar
  class Railtie < ::Rails::Railtie

    initializer 'radar.middleware.rails' do |app|
      require 'radar/middleware/rails/radar'
      app.config.middleware.insert_after ActionDispatch::DebugExceptions,
                                         Radar::Middleware::Rails::RadarMiddleware
    end
  end
end
