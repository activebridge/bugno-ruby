# frozen_string_literal: true

require 'rack'

module Bughub
  module RequestDataExtractor
    ALLOWED_HEADERS_REGEX = /^HTTP_|^CONTENT_TYPE$|^CONTENT_LENGTH$/.freeze
    ALLOWED_BODY_PARSEABLE_METHODS = %w[POST PUT PATCH DELETE].freeze

    def extract_request_data_from_rack(env)
      rack_req = ::Rack::Request.new(env)

      data = {
        url: request_url(env),
        ip_address: ip_address(env),
        headers: headers(env),
        http_method: request_method(env),
        params: get_params(rack_req)
      }
      data[:params] = post_params(rack_req) if data[:params].empty?
      data
    end

    def headers(env)
      env.keys.grep(ALLOWED_HEADERS_REGEX).map do |header|
        name = header.gsub(/^HTTP_/, '').split('_').map(&:capitalize).join('-')
        if name == 'Cookie'
          {}
        else
          { name => env[header] }
        end
      end.inject(:merge)
    end

    def request_method(env)
      env['REQUEST_METHOD'] || env[:method]
    end

    def request_url(env)
      forwarded_proto = env['HTTP_X_FORWARDED_PROTO'] || env['rack.url_scheme'] || ''
      scheme = forwarded_proto.split(',').first

      host = env['HTTP_X_FORWARDED_HOST'] || env['HTTP_HOST'] || env['SERVER_NAME'] || ''
      host = host.split(',').first.strip unless host.empty?

      path = env['ORIGINAL_FULLPATH'] || env['REQUEST_URI']
      unless path.nil? || path.empty?
        path = '/' + path.to_s if path.to_s.slice(0, 1) != '/'
      end

      port = env['HTTP_X_FORWARDED_PORT']
      if port && !(!scheme.nil? && scheme.casecmp('http').zero? && port.to_i == 80) && \
         !(!scheme.nil? && scheme.casecmp('https').zero? && port.to_i == 443) && \
         !(host.include? ':')
        host = host + ':' + port
      end

      [scheme, '://', host, path].join
    end

    def ip_address(env)
      ip_address_string = (env['action_dispatch.remote_ip'] || env['HTTP_X_REAL_IP'] || env['REMOTE_ADDR']).to_s
    end

    def get_params(rack_req)
      rack_req.GET
    rescue StandardError
      {}
    end

    def post_params(rack_req)
      rack_req.POST
    rescue StandardError
      {}
    end
  end
end
