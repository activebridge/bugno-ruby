# frozen_string_literal: true

RSpec.describe Bugno do
  it 'has a version number' do
    expect(Bugno::VERSION).not_to be nil
  end

  it 'has a configuration' do
    expect(Bugno::Configuration).not_to be nil
  end
end
