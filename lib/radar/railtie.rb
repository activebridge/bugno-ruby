require 'rails/railtie'

module Radar
  class Railtie < ::Rails::Railtie
    initializer 'radar.middleware.rails' do |app|
      require 'radar/middleware/rails/radar'
      require 'radar/middleware/rails/show_exceptions'
      app.config.middleware.insert_after ActionDispatch::DebugExceptions,
                                         Radar::Middleware::Rails::RadarMiddleware
      ActionDispatch::DebugExceptions.send(:include, Radar::Middleware::ShowExceptions)
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
