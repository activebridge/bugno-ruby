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
        rescue Error
          raise
        rescue Exception => e
          Handler.call(exception: e, job: job_data(job)) if Bugno.configured?
          raise e
        end

        def job_data(job)
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
