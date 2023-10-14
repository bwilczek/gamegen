# frozen_string_literal: true

require 'lex'

module Gamegen
  class MyLexer < Lex::Lexer
    # $strength = 8
    tokens(
      :NUMBER,
      :OPASSIGN,
      :VARNAME
    )

    rule(:OPASSIGN, /=/)
    rule(:VARNAME, /\$[a-z_]+[a-z0-9_]*/)
    rule(:NUMBER, /[0-9]+/) do |_lexer, token|
      token.value = token.value.to_i
      token
    end

    ignore " \t"
  end

  class Parser
    def initialize(variables:, constants:, enums:)
      @variables = variables
      @constants = constants
      @enums = enums
    end

    def parse(input)
      tokens = MyLexer.new.lex(input)
      tokens.to_a
    end
  end
end
