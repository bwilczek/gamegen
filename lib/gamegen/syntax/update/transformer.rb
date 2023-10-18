# frozen_string_literal: true

require 'parslet'

module Gamegen
  module Syntax
    module Update
      Assignment = Struct.new(:left, :right) do
        def eval
          "#{left.eval} = #{right.eval}"
        end
      end

      AssignmentWrapper = Struct.new(:assignment) do
        def eval
          assignment.eval
        end
      end

      class Transformer < Parslet::Transform
        rule(
          int: simple(:int)
        ) { Gamegen::Context.renderer.for_int(int) }

        rule(
          identifier: simple(:identifier)
        ) { Gamegen::Context.renderer.for_identifier(identifier) }

        rule(
          assignment: subtree(:assignment)
        ) { AssignmentWrapper.new(assignment) }

        rule(
          left: simple(:left),
          right: simple(:right)
        ) { Assignment.new(left, right) }
      end
    end
  end
end
