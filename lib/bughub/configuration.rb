# frozen_string_literal: true

module Bughub
  API_URL = 'https://bughub-api.herokuapp.com/'

  class Configuration
    attr_accessor :api_key
    attr_accessor :environment
    attr_accessor :framework
    attr_accessor :api_url

    def initialize
      @api_key = nil
      @environment = nil
      @framework = nil
      @api_url = API_URL
    end

    def get
      { environment: @environment,
        framework: @framework }
    end
  end
end
