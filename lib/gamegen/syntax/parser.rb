# frozen_string_literal: true

require 'parslet'

module Gamegen
  module Syntax
    class Parser < Parslet::Parser
      rule(:space) { match('\s').repeat(1) }
      rule(:space?) { space.maybe }
      rule(:lparen) { str('(') >> space? }
      rule(:rparen) { str(')') >> space? }

      rule(:bool) { (str('true') | str('false')).as(:bool) >> space? }
      rule(:integer) { match('[0-9]').repeat(1).as(:int) >> space? }
      rule(:identifier) { (match('[a-zA-Z=*]') >> match('[a-z0-9A-Z=*_]').repeat).as(:identifier) >> space? }
      rule(:value) { integer | bool | identifier }

      rule(:op_eq) { str('==') }
      rule(:op_neq) { str('!=') }
      rule(:op_lte) { str('<=') }
      rule(:op_gte) { str('>=') }
      rule(:op_gt) { str('>') }
      rule(:op_lt) { str('<') }
      rule(:cmp_operator) { (op_eq | op_neq | op_gte | op_lte | op_lt | op_gt).as(:comparison_operator) >> space? }

      rule(:op_assign) { str('=') }
      rule(:op_increment) { str('+=') }
      rule(:op_decrement) { str('-=') }
      rule(:mod_operator) { (op_assign | op_increment | op_decrement).as(:mod_operator) >> space? }

      rule(:op_and) { str('&&') }
      rule(:op_or) { str('||') }
      rule(:logical_operator) { (op_and | op_or).as(:logical_operator) >> space? }

      rule(:basic_condition) { identifier.as(:left) >> cmp_operator >> value.as(:right) }
      rule(:condition_in_parens) { lparen >> basic_condition >> rparen }

      rule(:logical_operand) { condition_in_parens | logical_operation_in_parens }
      rule(:logical_operation) { logical_operand.as(:left) >> logical_operator >> logical_operand.as(:right) }
      rule(:logical_operation_in_parens) { lparen >> logical_operation >> rparen }

      rule(:condition) { logical_operation | bool | basic_condition | condition_in_parens }
      rule(:assignment) { identifier.as(:left) >> mod_operator >> value.as(:right) }

      rule(:union) { assignment | condition }

      root(:union)
    end
  end
end
