# frozen_string_literal: true

module Bughub
  module Encoding
    class << self
      attr_accessor :encoding_class
    end

    def self.setup
      if String.instance_methods.include?(:encode)
        require 'bughub/encoding/encoder'
        self.encoding_class = Bughub::Encoding::Encoder
      else
        require 'bughub/encoding/legacy_encoder'
        self.encoding_class = Bughub::Encoding::LegacyEncoder
      end
    end

    def self.encode(object)
      can_be_encoded = object.is_a?(String) || object.is_a?(Symbol)

      return object unless can_be_encoded

      encoding_class.new(object).encode
    end
  end
end

Bughub::Encoding.setup
