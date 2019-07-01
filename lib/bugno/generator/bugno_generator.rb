# frozen_string_literal: true

require 'rails/generators'

class BugnoGenerator < Rails::Generators::Base
  source_root File.expand_path(__dir__)

  argument :api_key, required: false

  def generate_layout
    template 'bugno_initializer.rb.erb', 'config/initializers/bugno.rb'
  end
end
