# frozen_string_literal: true

module Gamegen
  class Renderer
    IncompatibleType = Class.new(StandardError)

    def initialize(view_module)
      @view_module = view_module
    end

    def for_int(int)
      @view_module.const_get(:IntegerLiteral).new(int)
    end

    def for_bool(bool)
      @view_module.const_get(:BoolLiteral).new(bool)
    end

    def for_operator(operator)
      @view_module.const_get(:DumbLiteral).new(operator)
    end

    def for_assignment(left, operator, right)
      operator = for_operator(operator)
      check_types(left, operator, right)
      @view_module.const_get(:Assignment).new(left, operator, right)
    end

    def for_comparison(left, operator, right)
      operator = for_operator(operator)
      check_types(left, operator, right)
      @view_module.const_get(:Comparison).new(left, operator, right)
    end

    def for_logical(left, operator, right)
      @view_module.const_get(:Logical).new(left, for_operator(operator), right)
    end

    def for_identifier(identifier)
      unless variables.keys.include?(identifier)
        raise IncompatibleType, "Unknown identifier: #{identifier}. Among: #{variables.keys}"
      end

      @view_module.const_get(:IdentifierLiteral).new(identifier)
    end

    private

    def check_types(left, operator, right) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      is_identifier = ->(o) { o.respond_to?(:identifier) }
      is_int = ->(o) { o.respond_to?(:int) }
      is_bool = ->(o) { o.respond_to?(:bool) }
      is_bool_operator = ->(o) { ['==', '!=', '='].include?(o.literal) }
      is_int_variable = ->(o) { is_identifier.call(o) && variables.dig(o.identifier.to_s, 'type') == 'int' }
      is_bool_variable = ->(o) { is_identifier.call(o) && variables.dig(o.identifier.to_s, 'type') == 'bool' }
      is_int_const = ->(o) { is_identifier.call(o) && constants.dig(o.identifier.to_s, 'type') == 'int' }
      is_bool_const = ->(o) { is_identifier.call(o) && constants.dig(o.identifier.to_s, 'type') == 'bool' }
      is_const = ->(o) { is_identifier.call(o) && constants.key?(o.identifier.to_s) }
      is_variable = ->(o) { is_identifier.call(o) && variables.key?(o.identifier.to_s) }
      resolves_to_int = ->(o) { is_int.call(o) || is_int_variable.call(o) || is_int_const.call(o) }
      resolves_to_bool = ->(o) { is_bool.call(o) || is_bool_variable.call(o) || is_bool_const.call(o) }
      resolved_type = lambda do |o|
        (resolves_to_int.call(o) ? 'int' : nil) || (resolves_to_bool.call(o) ? 'bool' : nil) || 'SOME_ENUM'
      end

      message = "#{left}, #{operator}, #{right}"
      unless is_identifier.call(left)
        raise IncompatibleType, "Left side of comparison or assignment has to be a variable. Details: #{message}"
      end

      unless is_identifier.call(left) && is_variable.call(left)
        raise IncompatibleType, "Variable #{left.identifier} does not exist. Details: #{message}"
      end

      unless resolved_type.call(left) == resolved_type.call(right)
        raise IncompatibleType, "Operands' type do not match. Details: #{message}"
      end

      if is_const.call(left)
        raise IncompatibleType, "Constants cannot be referred at the left operand. Details: #{message}"
      end

      if resolves_to_bool.call(left) && !is_bool_operator.call(operator)
        raise IncompatibleType, "Incorrect operand for boolean type. Details: #{message}"
      end

      # TODO: enums
      true
    end

    def constants
      Gamegen::Context.constants
    end

    def variables
      Gamegen::Context.variables
    end
  end
end
