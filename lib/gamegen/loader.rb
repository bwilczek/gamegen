# frozen_string_literal: true

module Gamegen
  class Loader
    def load(path)
      puts "Loading #{path}"
      Context.new
    end
  end
end
