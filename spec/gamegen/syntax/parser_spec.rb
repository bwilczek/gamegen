# frozen_string_literal: true

require 'gamegen/syntax/parser'

RSpec.describe(Gamegen::Syntax::Parser) do
  let(:parser) { described_class.new }

  describe '#parse' do
    let(:result) { parser.parse(input) }

    describe 'int literal assignment' do
      let(:input) { 'strength1 = 8' }

      specify do # rubocop:disable RSpec/MultipleExpectations
        expect(result.dig(:left, :identifier)).to eq('strength1')
        expect(result.dig(:right, :int)).to eq('8')
      end
    end

    describe 'bool literal assignment' do
      let(:input) { 'success_2 = true' }

      specify do # rubocop:disable RSpec/MultipleExpectations
        expect(result.dig(:left, :identifier)).to eq('success_2')
        expect(result.dig(:right, :bool)).to eq('true')
      end
    end

    describe 'int literal comparison' do
      let(:input) { 'strength >= 8' }

      specify do # rubocop:disable RSpec/MultipleExpectations
        expect(result.dig(:left, :identifier)).to eq('strength')
        expect(result[:comparison_operator]).to eq('>=')
        expect(result.dig(:right, :int)).to eq('8')
      end
    end

    describe 'comparison in parens' do
      let(:input) { '(strength >= 8)' }

      specify do # rubocop:disable RSpec/MultipleExpectations
        expect(result.dig(:left, :identifier)).to eq('strength')
        expect(result[:comparison_operator]).to eq('>=')
        expect(result.dig(:right, :int)).to eq('8')
      end
    end

    describe 'logical and of comparisons in parens' do
      let(:input) { '(strength >= 8) && (money < 3)' }

      specify do # rubocop:disable RSpec/MultipleExpectations
        expect(result.dig(:left, :comparison_operator)).to eq('>=')
        expect(result[:logical_operator]).to eq('&&')
        expect(result.dig(:right, :comparison_operator)).to eq('<')
      end
    end

    describe 'logical expression with nested parens' do
      let(:input) { '(strength >= 8) || ((character != mage) && (money == 20))' }

      specify do
        expect(result.dig(:right, :logical_operator)).to eq('&&')
      end
    end
  end
end
