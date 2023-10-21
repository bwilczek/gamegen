# frozen_string_literal: true

require 'parslet'

require_relative '../../context'

module Gamegen
  module Syntax
    module Condition
      class Transformer < Parslet::Transform
        rule(
          int: simple(:int)
        ) { Gamegen::Context.renderer.for_int(int) }

        rule(
          identifier: simple(:identifier)
        ) { Gamegen::Context.renderer.for_identifier(identifier) }

        rule(
          left: simple(:left),
          comparison_operator: simple(:comparison_operator),
          right: simple(:right)
        ) { Gamegen::Context.renderer.for_comparison(left, comparison_operator, right) }

        rule(
          left: subtree(:left),
          logical_operator: simple(:logical_operator),
          right: subtree(:right)
        ) { Gamegen::Context.renderer.for_logical(left, logical_operator, right) }
      end
    end
  end
end
