# frozen_string_literal: true

require 'gamegen/syntax/update/lexer'

RSpec.describe(Gamegen::Syntax::Update::Lexer) do
  let(:lexer) { described_class.new }
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

  describe '#lex' do
    let(:result) { lexer.lex(input) }

    describe 'complete expression' do
      let(:input) { 'strength = 8' }

      specify do
        expect(result).to include(
          an_object_having_attributes(name: :VARNAME, value: 'strength'),
          an_object_having_attributes(name: :OPASSIGN),
          an_object_having_attributes(name: :NUMBER, value: 8)
        )
      end
    end

    describe 'valid bool' do
      let(:input) { 'success = true' }

      specify do
        expect(result).to include(an_object_having_attributes(name: :BOOL, value: true))
      end
    end
  end
end
