# frozen_string_literal: true

require 'lex'

module Gamegen
  module Syntax
    module Ast
      class Identifier
        attr_accessor :name

        def initialize(name)
          @name = name
        end

        def ==(other)
          name == other&.name
        end

        def children
          []
        end
      end
    end
  end
end
