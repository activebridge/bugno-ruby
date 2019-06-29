# frozen_string_literal: true

require 'dummy_environment'
require 'bugno/event'

RSpec.describe Bugno::Event do
  let(:env) { DummyEnv.new.env }
  let(:exception) { DummyEnv.new.dummy_exception }
  let(:event) { Bugno::Event.new(exception, env).event }

  context 'returns hash with' do
    it 'timestamp' do
      expect(event[:timestamp]).to be_an(Integer)
    end

    it 'mesage' do
      expect(event[:message]).to eq(exception.message)
    end

    it 'backtrace' do
      expect(event[:backtrace]).to be_an(Array)
    end
  end
end
