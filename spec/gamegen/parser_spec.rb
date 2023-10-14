# frozen_string_literal: true

require_relative '../../lib/gamegen/parser'

RSpec.describe(Gamegen::Parser) do
  let(:parser) { described_class.new(variables:, constants:, enums:) }
  let(:variables) do
    {
      strength: { type: :int, initial: 3 },
      cat_lover: { type: :bool, initial: true },
      character: { type: :characters, initial: :mage }
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

  describe '#parse' do
    let(:result) { parser.parse(input) }

    describe 'assignment' do
      describe 'valid integer' do
        let(:input) { 'strength = 8' }

        specify do
          expect(result).to be_a(Hash)
        end
      end
    end
  end
end
