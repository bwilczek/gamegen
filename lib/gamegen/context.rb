# frozen_string_literal: true

module Gamegen
  class Context
    class << self
      attr_accessor :renderer, :variables, :constants, :enums
    end
  end
end
