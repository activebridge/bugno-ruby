# frozen_string_literal: true

require 'bugno/logger'
require 'bugno/configuration'
require 'bugno/event'

if defined?(Rails)
  require 'bugno/railtie'
  require 'bugno/generator/bugno_generator'
end

module Bugno
  class Error < StandardError; end

  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configured?
      !!configuration.api_key
    end

    def configure
      yield(configuration)
    end
  end
end
