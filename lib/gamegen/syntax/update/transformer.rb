# frozen_string_literal: true

require 'parslet'

module Gamegen
  module Syntax
    module Update
      class Transformer < Parslet::Transform
        rule(
          operator: simple(:operator)
        ) { Gamegen::Context.renderer.for_operator(operator) }

        rule(
          int: simple(:int)
        ) { Gamegen::Context.renderer.for_int(int) }

        rule(
          identifier: simple(:identifier)
        ) { Gamegen::Context.renderer.for_identifier(identifier) }

        rule(
          left: simple(:left),
          operator: simple(:operator),
          right: simple(:right)
        ) { Gamegen::Context.renderer.for_assignment(left, right) }
      end
    end
  end
end
