# frozen_string_literal: true

require 'gamegen/syntax/condition/parser'
require 'gamegen/syntax/condition/transformer'
require 'gamegen/renderer/javascript'
require 'gamegen/context'

RSpec.describe(Gamegen::Syntax::Condition::Transformer) do
  let(:transformer) { described_class.new }
  let(:parser) { Gamegen::Syntax::Condition::Parser.new }
  let(:renderer) { Gamegen::Renderer::Javascript.new }
  let(:variables) do
    {
      'strength' => { 'type' => 'int', 'initial' => 3 },
      'cat_lover' => { 'type' => 'bool', 'initial' => true },
      'character' => { 'type' => 'characters', 'initial' => 'mage' }
    }
  end
  let(:constants) do
    {
      price: { type: :int, initial: 2 }
    }
  end
  let(:enums) do
    {
      characters: %i[warrior mage]
    }
  end

  before do
    Gamegen::Context.renderer = renderer
    Gamegen::Context.variables = variables
    Gamegen::Context.constants = constants
    Gamegen::Context.enums = enums
    # puts parsed
  end

  describe '#apply' do
    let(:parsed) { parser.parse(input) }
    let(:ast) { transformer.apply(parsed) }
    let(:evaluated) { ast.eval }

    describe 'basic condition' do
      let(:input) { 'strength >= 8' }

      specify do
        expect(evaluated).to eq('strength >= 8')
      end
    end

    describe 'nested condition' do
      let(:input) { '(strength >= 8)' }

      specify do
        expect(evaluated).to eq('strength >= 8')
      end
    end

    describe 'and condition' do
      let(:input) { '(strength >= 8) && (strength > 2)' }

      specify do
        expect(evaluated).to eq('(strength >= 8) && (strength > 2)')
      end
    end

    describe 'nested logical condition' do
      let(:input) { '(strength >= 8) || ((strength >= 8) && (strength >= 8))' }

      specify do
        expect(evaluated).to eq('(strength >= 8) || ((strength >= 8) && (strength >= 8))')
      end
    end
  end
end
