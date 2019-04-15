require 'simplecov'
require 'pry'
require 'bundler/setup'
require 'radar'

SimpleCov.start
RSpec.configure do |config|
  config.include Radar
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
