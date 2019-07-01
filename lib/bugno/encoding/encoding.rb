# frozen_string_literal: true

module Bugno
  module Encoding
    class << self
      attr_accessor :encoding_class
    end

    def self.setup
      if String.instance_methods.include?(:encode)
        require 'bugno/encoding/encoder'
        self.encoding_class = Bugno::Encoding::Encoder
      else
        require 'bugno/encoding/legacy_encoder'
        self.encoding_class = Bugno::Encoding::LegacyEncoder
      end
    end

    def self.encode(object)
      can_be_encoded = object.is_a?(String) || object.is_a?(Symbol)

      return object unless can_be_encoded

      encoding_class.new(object).encode
    end
  end
end

Bugno::Encoding.setup
