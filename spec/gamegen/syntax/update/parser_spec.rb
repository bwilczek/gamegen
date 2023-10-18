# frozen_string_literal: true

require 'gamegen/syntax/update/parser'

RSpec.describe(Gamegen::Syntax::Update::Parser) do
  let(:parser) { described_class.new }

  describe '#parse' do
    let(:result) { parser.parse(input) }

    describe 'complete expression' do
      let(:input) { 'strength1 = 8' }

      specify do # rubocop:disable RSpec/MultipleExpectations
        expect(result.dig(:assignment, :left, :identifier)).to eq('strength1')
        expect(result.dig(:assignment, :right, :int)).to eq('8')
      end
    end

    describe 'valid bool' do
      let(:input) { 'success_2 = true' }

      specify do # rubocop:disable RSpec/MultipleExpectations
        expect(result.dig(:assignment, :left, :identifier)).to eq('success_2')
        expect(result.dig(:assignment, :right, :bool)).to eq('true')
      end
    end
  end
end
