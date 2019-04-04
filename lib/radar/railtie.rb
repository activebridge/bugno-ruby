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
          config.root ||= ::Rails.root
          config.framework = "Rails: #{::Rails::VERSION::STRING}"
          config.logger = proc { ::Rails.logger }
          config.environment = ENV['RACK_ENV'] || ::Rails.env
        end
      end
    end
  end
end
