# frozen_string_literal: true

require 'gamegen/syntax/condition/parser'

RSpec.describe(Gamegen::Syntax::Condition::Parser) do
  let(:parser) { described_class.new }

  describe '#parse' do
    let(:result) { parser.parse(input) }

    describe 'basic expression' do
      let(:input) { 'strength >= 8' }

      specify do # rubocop:disable RSpec/MultipleExpectations
        expect(result.dig(:left, :identifier)).to eq('strength')
        expect(result[:operator]).to eq('>=')
        expect(result.dig(:right, :int)).to eq('8')
      end
    end

    describe 'expression in parens' do
      let(:input) { '(strength >= 8)' }

      specify do # rubocop:disable RSpec/MultipleExpectations
        expect(result.dig(:left, :identifier)).to eq('strength')
        expect(result[:operator]).to eq('>=')
        expect(result.dig(:right, :int)).to eq('8')
      end
    end

    describe 'logical witout nesting parens' do
      let(:input) { '(strength >= 8) && (money < 3)' }

      specify do # rubocop:disable RSpec/MultipleExpectations
        expect(result.dig(:left, :operator)).to eq('>=')
        expect(result[:operator]).to eq('&&')
        expect(result.dig(:right, :operator)).to eq('<')
      end
    end

    describe 'complete expression' do
      let(:input) { '(strength >= 8) || ((character != mage) && (money == 20))' }

      specify do
        expect(result.dig(:right, :operator)).to eq('&&')
      end
    end
  end
end
