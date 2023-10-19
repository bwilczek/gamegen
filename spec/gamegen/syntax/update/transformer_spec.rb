# frozen_string_literal: true

require 'gamegen/syntax/update/parser'
require 'gamegen/syntax/update/transformer'
require 'gamegen/renderer/javascript'
require 'gamegen/context'

RSpec.describe(Gamegen::Syntax::Update::Transformer) do
  let(:transformer) { described_class.new }
  let(:parser) { Gamegen::Syntax::Update::Parser.new }
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
  end

  describe '#apply' do
    let(:parsed) { parser.parse(input) }
    let(:ast) { transformer.apply(parsed) }
    let(:evaluated) { ast.eval }

    describe 'integer assignment' do
      let(:input) { 'strength = 8' }

      specify do
        expect(evaluated).to eq('strength = 8')
      end
    end
  end
end
