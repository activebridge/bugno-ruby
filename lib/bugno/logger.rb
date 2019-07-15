# frozen_string_literal: true

module Bugno
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  %w[debug info warn error].each do |level|
    define_method(:"log_#{level}") do |message|
      logger.send(level, message)
    end
  end
end
