# frozen_string_literal: true

module Gamegen
  class Renderer
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

      BoolLiteral = Struct.new(:bool) do
        def eval
          bool == 'true'
        end
      end

      Assignment = Struct.new(:left, :operator, :right) do
        def eval
          "#{left.eval} #{operator.eval} #{right.eval}"
        end
      end

      Comparison = Struct.new(:left, :operator, :right) do
        def eval
          "#{left.eval} #{operator.eval} #{right.eval}"
        end
      end

      Logical = Struct.new(:left, :operator, :right) do
        def eval
          "(#{left.eval}) #{operator.eval} (#{right.eval})"
        end
      end

      IdentifierLiteral = Struct.new(:identifier) do
        def eval
          identifier.to_s
        end
      end
    end
  end
end
