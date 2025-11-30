# frozen_string_literal: true

require 'rails_helper'

describe TelegramBot::BodyParser do
  describe '#parse' do
    subject { described_class.new.parse(message) }

    describe '.rule :keyword' do
      let(:message) { "#{expression}values;" }

      context 'when valid' do
        let(:expected_element) { 'body' }
        let(:expression_key) { :keyword }

        elements = [
          'body:',
          'body: ',
          'body:  '
        ]

        include_examples 'parsed exactly', elements
      end
    end

    describe '.rule :value' do
      let(:message) { "body: [#{expression}];" }

      context 'when valid' do
        let(:expression_key) { :value }

        elements = [
          '01.01.2025; 12,01; Продукты'
        ]

        include_examples 'parsed succesfully', elements
      end
    end
  end
end
