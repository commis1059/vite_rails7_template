# frozen_string_literal: true

module Lib
  module Actions
    def source_paths
      [File.expand_path('../templates', File.dirname(__FILE__))]
    end
  end
end
