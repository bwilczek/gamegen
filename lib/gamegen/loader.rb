# frozen_string_literal: true

require 'yaml'
require 'pry'

module Gamegen
  class Loader
    NoSuchFile = Class.new(StandardError)

    def load(path)
      raise NoSuchFile, "Given file does not exist: #{path}" unless File.exist?(path)

      doc = YAML.load_file(path)

      context = Context.new

      binding.pry

      context
    end
  end
end
