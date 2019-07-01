# frozen_string_literal: true

require 'bugno/generator/bugno_generator'
require 'bugno/configuration'
require 'bugno/railtie'

module Bugno
  class Error < StandardError
  end

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
