# frozen_string_literal: true

require 'lex'

module Gamegen
  module Syntax
    module Ast
      class Assignment
        attr_accessor :left, :right

        def initialize(left, right)
          @left = left
          @right = right
        end

        def ==(other)
          children == other&.children
        end

        def children
          [left, right]
        end
      end
    end
  end
end
