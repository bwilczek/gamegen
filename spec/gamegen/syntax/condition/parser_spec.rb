# frozen_string_literal: true

require 'gamegen/syntax/condition/parser'

RSpec.describe(Gamegen::Syntax::Condition::Parser) do
  let(:parser) { described_class.new }

  describe '#parse' do
    let(:result) { parser.parse(input) }

    describe 'basic expression' do
      let(:input) { 'strength >= 8' }

      specify do
        binding.pry
      end
    end

    describe 'complete expression' do
      let(:input) { '(strength >= 8) || ((character != mage) && (money == 20))' }

      specify do
        # binding.pry
      end
    end
  end
end
