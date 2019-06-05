# frozen_string_literal: true

module Bughub
  API_URL = 'https://bughub-api.herokuapp.com/'
  IGNORE_DEFAULT = [
    'AbstractController::ActionNotFound',
    'ActionController::InvalidAuthenticityToken',
    'ActionController::RoutingError',
    'ActionController::UnknownAction',
    'ActiveRecord::RecordNotFound',
    'ActiveJob::DeserializationError'
  ].freeze

  class Configuration
    attr_accessor :api_key
    attr_accessor :environment
    attr_accessor :framework
    attr_accessor :api_url
    attr_accessor :exclude_rails_exceptions
    attr_accessor :excluded_exceptions

    def initialize
      @api_key = nil
      @environment = nil
      @framework = nil
      @api_url = API_URL
      @excluded_exceptions = IGNORE_DEFAULT
      @exclude_rails_exceptions = true
    end

    def get
      { environment: @environment,
        framework: @framework }
    end
  end
end
