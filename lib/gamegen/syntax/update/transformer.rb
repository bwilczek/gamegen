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

      IntLit = Struct.new(:int) do
        def eval
          int.to_i
        end
      end

      IdentifierLit = Struct.new(:identifier) do
        def eval
          identifier.to_s
        end
      end

      class Transformer < Parslet::Transform
        rule(
          int: simple(:int)
        ) { IntLit.new(int) }

        rule(
          identifier: simple(:identifier)
        ) { IdentifierLit.new(identifier) }

        rule(
          assignment: subtree(:assignment)
        ) { AssignmentWrapper.new(assignment) }

        rule(
          left: simple(:left),
          right: simple(:right)
        ) { Assignment.new(left, right) }

        def initialize(variables:, constants:, enums:)
          super
          @variables = variables
          @constants = constants
          @enums = enums
        end
      end
    end
  end
end
