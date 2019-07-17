# frozen_string_literal: true

module Bugno
  class << self
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    %w[debug info warn error].each do |level|
      define_method(:"log_#{level}") do |message|
        message = "[Bugno] #{message}"
        logger.send(level, message)
      end
    end
  end
end
