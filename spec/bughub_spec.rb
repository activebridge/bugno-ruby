# frozen_string_literal: true

RSpec.describe Bughub do
  it 'has a version number' do
    expect(Bughub::VERSION).not_to be nil
  end

  it 'has a configuration' do
    expect(Bughub::Configuration).not_to be nil
  end
end
