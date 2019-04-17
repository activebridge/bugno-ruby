require 'radar/reporter'

module Radar
  module Middleware
    module ShowExceptions
      def render_exception_with_radar(env, exception)
        if exception.is_a?(ActionController::RoutingError)
          Thread.new { Reporter.new(exception, extract_scope_from(env)).send }
        end

        render_exception_without_radar(env, exception)
      end

      def call_with_radar(env)
        call_without_radar(env)
      rescue ActionController::RoutingError => exception
        raise exception
      end

      def extract_scope_from(env)
        env.env
      end

      def self.included(base)
        base.send(:alias_method, :call_without_radar, :call)
        base.send(:alias_method, :call, :call_with_radar)

        base.send(:alias_method, :render_exception_without_radar, :render_exception)
        base.send(:alias_method, :render_exception, :render_exception_with_radar)
      end
    end
  end
end
