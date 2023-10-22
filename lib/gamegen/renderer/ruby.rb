# frozen_string_literal: true

module Gamegen
  module Renderer
    class Ruby
      DumbLiteral = Struct.new(:literal) do
        def eval
          literal.to_s
        end
      end

      IntegerLiteral = Struct.new(:int) do
        def eval
          int.to_i
        end
      end

      Assignment = Struct.new(:left, :right) do
        def validate
          return if right.respond_to?(Gamegen::Context.variables[left.identifier.to_s]['type'])

          raise "Incompatible type assignment for: #{Gamegen::Context.variables[left.identifier.to_s]['type']}"
        end

        def eval
          validate
          "#{left.eval} = #{right.eval}"
        end
      end

      Comparison = Struct.new(:left, :operator, :right) do
        def validate
          return if right.respond_to?(Gamegen::Context.variables[left.identifier.to_s]['type'])

          raise "Incompatible type comparison for: #{Gamegen::Context.variables[left.identifier.to_s]['type']}"
        end

        def eval
          validate
          "#{left.eval} #{operator.eval} #{right.eval}"
        end
      end

      Logical = Struct.new(:left, :operator, :right) do
        def eval
          "(#{left.eval}) #{operator.eval} (#{right.eval})"
        end
      end

      IdentifierLiteral = Struct.new(:identifier) do
        def validate
          return if Gamegen::Context.variables.keys.include?(identifier)

          raise "Unknown identifier: #{identifier}. Among: #{Gamegen::Context.variables.keys}"
        end

        def eval
          validate
          identifier.to_s
        end
      end

      def for_int(int)
        IntegerLiteral.new(int)
      end

      def for_operator(operator)
        DumbLiteral.new(operator)
      end

      def for_assignment(left, rigth)
        Assignment.new(left, rigth)
      end

      def for_comparison(left, operator, rigth)
        Comparison.new(left, for_operator(operator), rigth)
      end

      def for_logical(left, operator, rigth)
        Logical.new(left, for_operator(operator), rigth)
      end

      def for_identifier(identifier)
        IdentifierLiteral.new(identifier)
      end

      def variables
        Gamegen::Context.variables
      end
    end
  end
end