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
          operator: simple(:operator),
          right: simple(:right)
        ) { Gamegen::Context.renderer.for_comparison(left, operator, right) }
      end
    end
  end
end
