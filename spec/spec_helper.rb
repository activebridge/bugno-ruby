# frozen_string_literal: true

require 'simplecov'
require 'pry'
require 'bundler/setup'
require 'bugno'

SimpleCov.start
RSpec.configure do |config|
  config.include Bugno
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
