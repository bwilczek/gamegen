# frozen_string_literal: true

require 'gamegen/syntax/parser'
require 'gamegen/syntax/transformer'
require 'gamegen/renderer'
require 'gamegen/renderer/ruby'
require 'gamegen/context'

RSpec.describe(Gamegen::Syntax::Transformer) do
  let(:transformer) { described_class.new }
  let(:parser) { Gamegen::Syntax::Parser.new }
  let(:renderer) { Gamegen::Renderer.new(renderer_views) }
  let(:renderer_views) { Gamegen::Renderer::Ruby }
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

    describe 'integer literal assignment' do
      let(:input) { 'strength = 8' }

      specify do
        expect(evaluated).to eq('strength = 8')
      end
    end

    describe 'integer incremental assignment' do
      let(:input) { 'strength += 8' }

      specify do
        expect(evaluated).to eq('strength += 8')
      end
    end

    describe 'assign to int literal' do
      let(:input) { '12 = true' }

      specify do
        expect { evaluated }.to raise_error(Parslet::ParseFailed)
      end
    end

    describe 'assign bool literal to int' do
      let(:input) { 'strength = true' }

      specify do
        expect { evaluated }.to raise_error(Gamegen::Renderer::IncompatibleType, /Operands' type do not match/)
      end
    end

    describe 'invalid comparison operator for boolean' do
      let(:input) { 'cat_lover >= true' }

      specify do
        expect { evaluated }.to raise_error(Gamegen::Renderer::IncompatibleType, /Incorrect operand for boolean/)
      end
    end

    describe 'undefined variable' do
      let(:input) { 'spam = true' }

      specify do
        expect { evaluated }.to raise_error(Gamegen::Renderer::IncompatibleType, /Unknown identifier/)
      end
    end

    describe 'undefined const' do
      let(:input) { 'strength += spam' }

      specify do
        expect { evaluated }.to raise_error(Gamegen::Renderer::IncompatibleType, /Unknown identifier/)
      end
    end
  end
end
