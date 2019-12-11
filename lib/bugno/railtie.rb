# frozen_string_literal: true

require 'rails/railtie'

module Bugno
  class Railtie < ::Rails::Railtie
    initializer 'bugno.middleware.rails' do |app|
      require 'bugno/middleware/rails/bugno'
      require 'bugno/middleware/rails/show_exceptions'
      require 'bugno/middleware/rails/active_job_extensions'
      app.config.middleware.insert_after ActionDispatch::DebugExceptions,
                                         Bugno::Middleware::Rails::BugnoMiddleware
      ActionDispatch::DebugExceptions.send(:include, Bugno::Middleware::ShowExceptions)
    end

    initializer 'bugno.configuration' do
      config.after_initialize do
        Bugno.configure do |config|
          config.environment = ENV['RACK_ENV'] || ::Rails.env
          config.framework = 'rails'
        end
      end
    end
  end
end
