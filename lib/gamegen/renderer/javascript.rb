# frozen_string_literal: true

module Gamegen
  module Renderer
    class Javascript
      IntegerLiteral = Struct.new(:int) do
        def eval
          int.to_i
        end
      end

      IdentifierLiteral = Struct.new(:identifier) do
        def validate
          raise "Unknown identifier: #{identifier}. Among: #{Gamegen::Context.variables.keys}" unless Gamegen::Context.variables.keys.include?(identifier)
        end

        def eval
          validate
          identifier.to_s
        end
      end

      def for_int(int)
        IntegerLiteral.new(int)
      end

      def for_identifier(identifier)
        IdentifierLiteral.new(identifier)
      end
    end
  end
end
