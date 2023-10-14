# frozen_string_literal: true

module Gamegen
  class Parser
    def initialize(variables:, constants:, enums:)
      @variables = variables
      @constants = constants
      @enums = enums
    end

    def parse(input)
      {}
    end
  end
end
