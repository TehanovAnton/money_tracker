# frozen_string_literal: true

require 'rails_helper'

describe BodyParser do
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

        it_behaves_like 'parsed succesfully', elements
      end
    end

    describe '.rule spreadsheet_id' do
      subject(:spreadsheet_id) { described_class.new.parse(message)[:spreadsheet_id] }

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
          expect(spreadsheet_id).to eq(expression)
        end
      end
    end

    describe '.rule sheet_range' do
      subject(:sheet_range) { described_class.new.parse(message)[:sheet_range] }

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
          expect(sheet_range).to eq(expression)
        end
      end
    end

    describe '.rule comment' do
      subject(:comment) { described_class.new.parse(message)[:comment] }

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
          expect(comment).to eq(expression)
        end
      end
    end
  end
end
