# frozen_string_literal: true

require 'parslet'

require_relative '../context'

module Gamegen
  module Syntax
    class Transformer < Parslet::Transform
      rule(
        int: simple(:int)
      ) { Gamegen::Context.renderer.for_int(int) }

      rule(
        bool: simple(:bool)
      ) { Gamegen::Context.renderer.for_bool(bool) }

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

      rule(
        left: simple(:left),
        mod_operator: simple(:mod_operator),
        right: simple(:right)
      ) { Gamegen::Context.renderer.for_assignment(left, mod_operator, right) }
    end
  end
end
