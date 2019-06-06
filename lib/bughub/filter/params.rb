# frozen_string_literal: true

require 'tempfile'

module Bughub
  module Filter
    class Params
      SKIPPED_CLASSES = [::Tempfile].freeze
      ATTACHMENT_CLASSES = %w[ActionDispatch::Http::UploadedFile Rack::Multipart::UploadedFile].freeze
      SCRUB_ALL = :scrub_all

      def self.call(*args)
        new.call(*args)
      end

      def call(options = {})
        params = options[:params]
        return {} unless params

        @scrubbed_object_ids = {}

        config = options[:config]
        extra_fields = options[:extra_fields]
        whitelist = options[:whitelist] || []

        scrub(params, build_scrub_options(config, extra_fields, whitelist))
      end

      private

      def build_scrub_options(config, extra_fields, whitelist)
        ary_config = Array(config)

        {
          fields_regex: build_fields_regex(ary_config, extra_fields),
          scrub_all: ary_config.include?(SCRUB_ALL),
          whitelist: build_whitelist_regex(whitelist)
        }
      end

      def build_fields_regex(config, extra_fields)
        fields = config.find_all { |f| f.is_a?(String) || f.is_a?(Symbol) }
        fields += Array(extra_fields)

        return unless fields.any?

        Regexp.new(fields.map { |val| Regexp.escape(val.to_s).to_s }.join('|'), true)
      end

      def build_whitelist_regex(whitelist)
        fields = whitelist.find_all { |f| f.is_a?(String) || f.is_a?(Symbol) }
        return unless fields.any?

        Regexp.new(fields.map { |val| /\A#{Regexp.escape(val.to_s)}\z/ }.join('|'))
      end

      def scrub(params, options)
        return params if @scrubbed_object_ids[params.object_id]

        @scrubbed_object_ids[params.object_id] = true

        fields_regex = options[:fields_regex]
        scrub_all = options[:scrub_all]
        whitelist_regex = options[:whitelist]

        return scrub_array(params, options) if params.is_a?(Array)

        params.to_hash.each_with_object({}) do |(key, value), result|
          encoded_key = Bughub::Encoding.encode(key).to_s
          result[key] = if (fields_regex === encoded_key) && !(whitelist_regex === encoded_key)
                          scrub_value
                        elsif value.is_a?(Hash)
                          scrub(value, options)
                        elsif scrub_all && !(whitelist_regex === encoded_key)
                          scrub_value
                        elsif value.is_a?(Array)
                          scrub_array(value, options)
                        elsif skip_value?(value)
                          "Skipped value of class '#{value.class.name}'"
                        else
                          bughub_filtered_param_value(value)
                        end
        end
      end

      def scrub_array(array, options)
        array.map do |value|
          value.is_a?(Hash) ? scrub(value, options) : bughub_filtered_param_value(value)
        end
      end

      def scrub_value
        '[FILTERED]'
      end

      def bughub_filtered_param_value(value)
        if ATTACHMENT_CLASSES.include?(value.class.name)
          begin
            attachment_value(value)
          rescue StandardError
            'Uploaded file'
          end
        else
          value
        end
      end

      def skip_value?(value)
        SKIPPED_CLASSES.any? { |klass| value.is_a?(klass) }
      end
    end
  end
end
