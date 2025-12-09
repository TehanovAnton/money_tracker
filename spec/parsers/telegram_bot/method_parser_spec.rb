# frozen_string_literal: true

require 'rails_helper'

describe TelegramBot::MethodParser do
  describe '#parse' do
    subject { described_class.new.parse(message) }

    describe '.rule :keyword' do
      let(:message) { "#{expression}get;" }

      context 'when valid' do
        let(:expected_element) { 'method' }
        let(:expression_key) { :keyword }

        elements = [
          'method:',
          'method: ',
          'method:  '
        ]

        it_behaves_like 'parsed exactly', elements
      end

      context 'when invalid' do
        elements = [
          'mthod:',
          'Method:',
          'meThod:',
          'method;',
          'method:-',
          'method'
        ]

        it_behaves_like 'parsing error', elements
      end
    end

    describe '.rule :value' do
      let(:message) { "method: #{expression}" }

      context 'when valid' do
        let(:expected_element) { 'get' }
        let(:expression_key) { :value }

        elements = [
          'get;'
        ]

        it_behaves_like 'parsed exactly', elements
      end

      context 'when invalid' do
        let(:expected_colon) { ':' }

        elements = [
          'get',
          'Get;',
          'get ;',
          '12324;'
        ]

        it_behaves_like 'parsing error', elements
      end
    end
  end
end
