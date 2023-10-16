# frozen_string_literal: true

require 'lex'

module Gamegen
  module Syntax
    module Update
      class Lexer < Lex::Lexer
        tokens(
          :NUMBER,
          :OPASSIGN,
          :VARNAME,
          :BOOL
        )

        rule(:OPASSIGN, /=/)
        rule(:BOOL, /true|false/) do |_lexer, token|
          token.value = token.value == 'true'
          token
        end
        rule(:VARNAME, /[a-z_]+[a-z0-9_]*/)
        rule(:NUMBER, /[0-9]+/) do |_lexer, token|
          token.value = token.value.to_i
          token
        end

        ignore " \t"
      end
    end
  end
end
