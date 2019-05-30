# frozen_string_literal: true

require 'bughub/generator/bughub_generator'
require 'bughub/configuration'
require 'bughub/railtie'

module Bughub
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
