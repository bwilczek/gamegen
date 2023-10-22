# frozen_string_literal: true

module Gamegen
  class Renderer
    def initialize(view_module)
      @view_module = view_module
    end

    def for_int(int)
      @view_module.const_get(:IntegerLiteral).new(int)
    end

    def for_operator(operator)
      @view_module.const_get(:DumbLiteral).new(operator)
    end

    def for_assignment(left, operator, right)
      unless right.respond_to?(variables[left.identifier.to_s]['type'])
        raise "Incompatible type assignment for: #{variables[left.identifier.to_s]['type']}"
      end

      @view_module.const_get(:Assignment).new(left, for_operator(operator), right)
    end

    def for_comparison(left, operator, right)
      unless right.respond_to?(variables[left.identifier.to_s]['type'])
        raise "Incompatible type comparison for: #{variables[left.identifier.to_s]['type']}"
      end

      @view_module.const_get(:Comparison).new(left, for_operator(operator), right)
    end

    def for_logical(left, operator, right)
      @view_module.const_get(:Logical).new(left, for_operator(operator), right)
    end

    def for_identifier(identifier)
      raise "Unknown identifier: #{identifier}. Among: #{variables.keys}" unless variables.keys.include?(identifier)

      @view_module.const_get(:IdentifierLiteral).new(identifier)
    end

    private

    def variables
      Gamegen::Context.variables
    end
  end
end
