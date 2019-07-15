# frozen_string_literal: true

module Bugno
  API_URL = 'https://api.bugno.io'
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
    attr_accessor :scrub_fields
    attr_accessor :scrub_headers
    attr_accessor :scrub_user
    attr_accessor :scrub_password
    attr_accessor :scrub_whitelist
    attr_accessor :current_user_method

    def initialize
      @api_key = nil
      @environment = nil
      @framework = 'rails'
      @api_url = API_URL
      @excluded_exceptions = IGNORE_DEFAULT
      @exclude_rails_exceptions = true
      @scrub_fields = %i[passwd password password_confirmation secret
                         confirm_password password_confirmation secret_token
                         api_key access_token session_id]
      @scrub_headers = ['Authorization']
      @scrub_user = true
      @scrub_password = true
      @scrub_whitelist = []
      @current_user_method = 'current_user'
    end
  end
end
