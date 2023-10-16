# frozen_string_literal: true

require_relative 'condition/lexer'

module Gamegen
  module Syntax
    class Condition
      def initialize(statement:, renderer:, symbols:)
        @statement = statement
        @renderer = renderer
        @symbols = symbols
      end

      def process
        tokens = Lexer.new.lex(input)
        ast = Parser.new(tokens, symbols)
        renderer.render(ast)
      end
    end
  end
end
