require 'rails/generators'

class RadarGenerator < Rails::Generators::Base
  source_root File.expand_path(__dir__)

  argument :api_key, required: false

  def generate_layout
    template 'radar_initializer.rb.erb', 'config/initializers/radar.rb'
  end
end
