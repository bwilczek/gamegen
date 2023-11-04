# frozen_string_literal: true

require 'forwardable'

module Gamegen
  class Context
    class << self
      extend Forwardable
      def_delegators :instance, # *instance_methods(false)
                     :renderer, :variables, :constants, :enums, :scenes, :characters,
                     :renderer=, :variables=, :constants=, :enums=, :scenes=, :characters=

      def instance
        @instance ||= new
      end

      def load(context)
        @instance = context
      end
    end

    attr_accessor :renderer, :variables, :constants, :enums, :scenes
  end
end
