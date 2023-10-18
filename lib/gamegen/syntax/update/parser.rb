# frozen_string_literal: true

require 'parslet'

module Gamegen
  module Syntax
    module Update
      class Parser < Parslet::Parser
        # strength = 8
        rule(:space) { match('\s').repeat(1) }
        rule(:space?) { space.maybe }
        rule(:bool_true) { str('true') }
        rule(:bool_false) { str('false') }
        rule(:bool) { (bool_true | bool_false).as(:bool) >> space? }
        rule(:integer) { match('[0-9]').repeat(1).as(:int) >> space? }
        rule(:identifier) { match['[a-z][a-z0-9_]'].repeat(1).as(:identifier) >> space? }
        rule(:op_assign) { match('[=]') >> space? }
        rule(:value) { integer | bool | identifier }

        rule(:assignment) { (identifier.as(:left) >> op_assign >> value.as(:right)).as(:assignment) }
        root(:assignment)
      end
    end
  end
end
