# frozen_string_literal: true

require 'active_support/testing/time_helpers'

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers

  config.after do
    travel_back
  end
end
