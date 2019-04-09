require 'rails/railtie'

module Radar
  class Railtie < ::Rails::Railtie
    initializer 'radar.middleware.rails' do |app|
      require 'radar/middleware/rails/radar'
      app.config.middleware.insert_after ActionDispatch::DebugExceptions,
                                         Radar::Middleware::Rails::RadarMiddleware
    end

    initializer 'radar.configuration' do
      config.after_initialize do
        Radar.configure do |config|
          config.framework = "Rails: #{::Rails::VERSION::STRING}"
          config.environment = ENV['RACK_ENV'] || ::Rails.env
        end
      end
    end
  end
end
