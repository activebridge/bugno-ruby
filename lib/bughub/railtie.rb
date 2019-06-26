# frozen_string_literal: true

require 'rails/railtie'

module Bughub
  class Railtie < ::Rails::Railtie
    initializer 'bughub.middleware.rails' do |app|
      require 'bughub/middleware/rails/bughub'
      require 'bughub/middleware/rails/show_exceptions'
      app.config.middleware.insert_after ActionDispatch::DebugExceptions,
                                         Bughub::Middleware::Rails::BughubMiddleware
      ActionDispatch::DebugExceptions.send(:include, Bughub::Middleware::ShowExceptions)
    end

    initializer 'bughub.configuration' do
      config.after_initialize do
        Bughub.configure do |config|
          config.environment = ENV['RACK_ENV'] || ::Rails.env
        end
      end
    end
  end
end
