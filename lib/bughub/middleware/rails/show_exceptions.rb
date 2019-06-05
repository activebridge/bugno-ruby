# frozen_string_literal: true

require 'bughub/reporter'

module Bughub
  module Middleware
    module ShowExceptions
      def render_exception_with_bughub(env, exception)
        if exception.is_a?(ActionController::RoutingError)
          Thread.new { Reporter.new(exception, extract_scope_from(env)).send } unless excluded_exception?(exception)
        end

        render_exception_without_bughub(env, exception)
      end

      def excluded_exception?(exception)
        Bughub.configuration.exclude_rails_exceptions && \
          Bughub.configuration.excluded_exceptions.include?(exception.class.inspect)
      end

      def call_with_bughub(env)
        call_without_bughub(env)
      rescue ActionController::RoutingError => e
        raise e
      end

      def extract_scope_from(env)
        env.env
      end

      def self.included(base)
        base.send(:alias_method, :call_without_bughub, :call)
        base.send(:alias_method, :call, :call_with_bughub)

        base.send(:alias_method, :render_exception_without_bughub, :render_exception)
        base.send(:alias_method, :render_exception, :render_exception_with_bughub)
      end
    end
  end
end
