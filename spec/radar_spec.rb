RSpec.describe Radar do
  it 'has a version number' do
    expect(Radar::VERSION).not_to be nil
  end

  it 'has a configuration' do
    expect(Radar::Configuration).not_to be nil
  end
end
