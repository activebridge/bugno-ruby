# frozen_string_literal: true

require 'bugno/handler'

module Bugno
  module Middleware
    module Rails
      module ActiveJobExtensions
        ADAPTERS = %w[ActiveJob::QueueAdapters::SidekiqAdapter ActiveJob::QueueAdapters::DelayedJobAdapter].freeze

        def self.included(base)
          base.class_eval do
            around_perform { |job, block| capture_and_reraise(job, block) }
          end
        end

        def capture_and_reraise(job, block)
          block.call
        rescue Exception => e

          Handler.new(e, job: job_data(job)).handle_exception if Bugno.configured?
          raise e
        end

        def supported_by_specific_integration?(job)
          return ADAPTERS.include?(job.class.queue_adapter.to_s) if ::Rails.version.to_f < 5.0

          ADAPTERS.include?(job.class.queue_adapter.class.to_s)
        end

        def job_data(job)
          return {} if supported_by_specific_integration?(job)
          data = {
            active_job: job.class.name,
            arguments: job.arguments,
            scheduled_at: job.scheduled_at,
            job_id: job.job_id,
            locale: job.locale
          }
          data[:provider_job_id] = job.provider_job_id if job.respond_to?(:provider_job_id)
          data
        end
      end
    end
  end
end

class ActiveJob::Base
  include Bugno::Middleware::Rails::ActiveJobExtensions
end
