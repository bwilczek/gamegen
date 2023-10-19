# frozen_string_literal: true

module Gamegen
  module Renderer
    class Javascript
      DumbLiteral = Struct.new(:literal) do
        def eval
          literal
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

      def for_identifier(identifier)
        IdentifierLiteral.new(identifier)
      end
    end
  end
end
