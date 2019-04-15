require 'dummy_environment'
require 'radar/event'

RSpec.describe Radar::Event do
  let(:env) { DummyEnv.new.env }
  let(:exception) { DummyEnv.new.dummy_exception }
  let(:event) { Radar::Event.new(exception, env).event }

  context 'returns hash with' do
    it 'timestamp' do
      expect(event[:timestamp]).to be_an(Integer)
    end

    it 'mesage' do
      expect(event[:message]).to eq(exception.message)
    end

    it 'backtrace' do
      expect(event[:backtrace]).to eq(exception.backtrace)
    end
  end
end
