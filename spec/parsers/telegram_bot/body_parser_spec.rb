# frozen_string_literal: true

require 'rails_helper'

describe TelegramBot::BodyParser do
  describe '#parse' do
    subject { described_class.new.parse(message) }

    describe '.rule :value' do
      let(:message) do
        <<-TEXT.strip
          body:
            spreadsheet_id: sadfasdflkasd;
            sheet_range: Октябрь!L30:N37;
            [#{expression}];
        TEXT
      end

      context 'when valid' do
        let(:expression_key) { :value }

        elements = [
          '01.01.2025; 12,01; Продукты'
        ]

        include_examples 'parsed succesfully', elements
      end
    end

    describe '.rule spreadsheet_id' do
      let(:message) do
        <<-TEXT.strip
          body:
            spreadsheet_id: #{expression};
            sheet_range: Октябрь!L30:N37;
            [01.01.2025; 12,01; Продукты];
        TEXT
      end

      context 'when valid' do
        let(:expression) { '1CJ7WjtT3U0vZiO7l3cBCGYIQcwPbTAG46LjZrNO02nI' }

        it do
          expect(subject[:spreadsheet_id]).to eq(expression)
        end
      end
    end

    describe '.rule sheet_range' do
      let(:message) do
        <<-TEXT.strip
          body:
            spreadsheet_id: asdcaoimacsodicm;
            sheet_range: #{expression};
            [01.01.2025; 12,01; Продукты];
        TEXT
      end

      context 'when valid' do
        let(:expression) { 'Октябрь!L30:N37' }

        it do
          expect(subject[:sheet_range]).to eq(expression)
        end
      end
    end

    describe '.rule comment' do
      let(:message) do
        <<-TEXT.strip
          body:
            spreadsheet_id: asdcaoimacsodicm;
            sheet_range: Октябрь!L30:N37;
            [01.01.2025; 12,01; Продукты; #{expression}];
        TEXT
      end

      context 'when valid' do
        let(:expression) { 'Немного коментов' }

        it do
          expect(subject[:comment]).to eq(expression)
        end
      end
    end
  end
end
