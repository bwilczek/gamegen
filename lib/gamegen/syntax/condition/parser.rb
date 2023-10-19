# frozen_string_literal: true

require 'parslet'

module Gamegen
  module Syntax
    module Condition
      class Parser < Parslet::Parser
        # (strength >= 8) || ((character != mage) && (money == 20))

        rule(:space) { match('\s').repeat(1) }
        rule(:space?) { space.maybe }
        rule(:bool) { (str('true') | str('false')).as(:bool) >> space? }
        rule(:integer) { match('[0-9]').repeat(1).as(:int) >> space? }
        rule(:identifier) { (match('[a-zA-Z=*]') >> match('[a-z0-9A-Z=*_]').repeat).as(:identifier) >> space? }
        rule(:op_eq) { str('==') }
        rule(:op_neq) { str('!=') }
        rule(:op_lte) { str('<=') }
        rule(:op_gte) { str('>=') }
        rule(:op_gt) { str('>') }
        rule(:op_lt) { str('<') }
        rule(:operator) { (op_eq | op_neq | op_gte | op_lte | op_lt | op_gt).as(:operator) >> space? }
        rule(:value) { integer | bool | identifier }

        rule(:basic_condition) { identifier.as(:left) >> operator >> value.as(:right) }

        rule(:condition) { bool | basic_condition }
        root(:condition)
      end
    end
  end
end
