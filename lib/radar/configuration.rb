module Radar
  API_URL = 'https://api-radar.herokuapp.com'

  class Configuration
    attr_accessor :api_key
    attr_accessor :environment
    attr_accessor :logger
    attr_accessor :root
    attr_accessor :framework
    attr_accessor :api_url

    def initialize
      @api_key = nil
      @environment = nil
      @logger = nil
      @root = nil
      @framework = nil
      @api_url = API_URL
    end

    def get
      { api_key: @api_key,
        environment: @environment,
        logger: @logger,
        root: @root,
        framework: @framework }
    end
  end
end
