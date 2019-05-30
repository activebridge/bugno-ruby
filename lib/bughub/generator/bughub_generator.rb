# frozen_string_literal: true

require 'rails/generators'

class BughubGenerator < Rails::Generators::Base
  source_root File.expand_path(__dir__)

  argument :api_key, required: false

  def generate_layout
    template 'bughub_initializer.rb.erb', 'config/initializers/bughub.rb'
  end
end
