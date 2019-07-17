# frozen_string_literal: true

require 'rack'
require 'bugno/filter/params'
require 'bugno/encoding/encoder'

module Bugno
  module RequestDataExtractor
    ALLOWED_HEADERS_REGEX = /^HTTP_|^CONTENT_TYPE$|^CONTENT_LENGTH$/.freeze
    ALLOWED_BODY_PARSEABLE_METHODS = %w[POST PUT PATCH DELETE].freeze

    def extract_request_data_from_rack(env)
      rack_req = ::Rack::Request.new(env)
      sensitive_params = sensitive_params_list(env)

      post_params = scrub_params(post_params(rack_req), sensitive_params)
      get_params = scrub_params(get_params(rack_req), sensitive_params)
      route_params = scrub_params(route_params(env), sensitive_params)
      session = scrub_params(request_session(env), sensitive_params)
      cookies = scrub_params(request_cookies(rack_req), sensitive_params)
      person_data = scrub_params(person_data(env), sensitive_params)

      data = {
        url: request_url(env),
        ip_address: ip_address(env),
        headers: headers(env),
        http_method: request_method(env),
        params: get_params,
        route_params: route_params,
        session: session,
        cookies: cookies,
        person_data: person_data
      }
      data[:params] = post_params if data[:params].empty?

      data
    end

    def scrub_params(params, sensitive_params)
      options = {
        params: params,
        config: Bugno.configuration.scrub_fields,
        extra_fields: sensitive_params,
        whitelist: Bugno.configuration.scrub_whitelist
      }
      Bugno::Filter::Params.call(options)
    end

    def person_data(env)
      current_user = Bugno.configuration.current_user_method
      controller = env['action_controller.instance']
      person_data = begin
                      controller.send(current_user).attributes
                    rescue StandardError
                      {}
                    end
      person_data
    end

    def sensitive_params_list(env)
      Array(env['action_dispatch.parameter_filter'])
    end

    def request_session(env)
      session = env.fetch('rack.session', {})

      session.to_hash
    rescue StandardError
      {}
    end

    def request_cookies(rack_req)
      rack_req.cookies
    rescue StandardError
      {}
    end

    def headers(env)
      env.keys.grep(ALLOWED_HEADERS_REGEX).map do |header|
        name = header.gsub(/^HTTP_/, '').split('_').map(&:capitalize).join('-')
        if name == 'Cookie'
          {}
        elsif sensitive_headers_list.include?(name)
          { name => Bugno::Params.scrub_value(env[header]) }
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

    def route_params(env)
      return {} unless defined?(Rails)

      begin
        environment = { method: request_method(env) }

        ::Rails.application.routes.recognize_path(env['PATH_INFO'],
                                                  environment)
      rescue StandardError
        {}
      end
    end

    def sensitive_headers_list
      Bugno.configuration.scrub_headers || []
    end
  end
end
