# frozen_string_literal: true

require 'bugno/configuration'

RSpec.describe Bugno::Configuration do
  let(:configuration) { Bugno::Configuration.new }

  context 'has' do
    it 'an api_key' do
      configuration.api_key = SecureRandom.urlsafe_base64
      expect(configuration.api_key).to be
    end

    it 'an api_url' do
      expect(configuration.api_url).to be
    end
  end
end
