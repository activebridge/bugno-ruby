require 'radar/configuration'
require 'radar/version'
require 'radar/middleware/rails/radar'
require 'radar/railtie'

module Radar
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
