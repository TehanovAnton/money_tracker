# frozen_string_literal: true

require 'rails_helper'

describe ActionParser do
  describe '#parse' do
    subject { described_class.new.parse(message) }

    describe '.rule :keyword' do
      let(:message) { "#{expression}upsert;" }

      context 'when valid' do
        let(:expected_element) { 'action' }
        let(:expression_key) { :keyword }

        elements = [
          'action:',
          'action: ',
          'action:  '
        ]

        it_behaves_like 'parsed exactly', elements
      end

      context 'when invalid' do
        elements = [
          'ation:',
          'Action:',
          'actIon:',
          'action;',
          'action:-',
          'action'
        ]

        it_behaves_like 'parsing error', elements
      end
    end

    describe '.rule :value' do
      let(:message) { "action: #{expression}" }

      context 'when valid' do
        let(:expected_element) { 'upsert' }
        let(:expression_key) { :value }

        elements = [
          'upsert;'
        ]

        it_behaves_like 'parsed exactly', elements
      end

      context 'when invalid' do
        let(:expected_colon) { ':' }

        elements = [
          'upsert',
          'Upsert;',
          'upsert ;',
          '12324;'
        ]

        it_behaves_like 'parsing error', elements
      end
    end
  end
end
