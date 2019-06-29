# frozen_string_literal: true

require 'bugno/reporter'

module Bugno
  module Middleware
    module ShowExceptions
      def render_exception_with_bugno(env, exception)
        if exception.is_a?(ActionController::RoutingError)
          Thread.new { Reporter.new(exception, extract_scope_from(env)).send } unless excluded_exception?(exception)
        end

        render_exception_without_bugno(env, exception)
      end

      def excluded_exception?(exception)
        Bugno.configuration.exclude_rails_exceptions && \
          Bugno.configuration.excluded_exceptions.include?(exception.class.inspect)
      end

      def call_with_bugno(env)
        call_without_bugno(env)
      rescue ActionController::RoutingError => e
        raise e
      end

      def extract_scope_from(env)
        env.env
      end

      def self.included(base)
        base.send(:alias_method, :call_without_bugno, :call)
        base.send(:alias_method, :call, :call_with_bugno)

        base.send(:alias_method, :render_exception_without_bugno, :render_exception)
        base.send(:alias_method, :render_exception, :render_exception_with_bugno)
      end
    end
  end
end
