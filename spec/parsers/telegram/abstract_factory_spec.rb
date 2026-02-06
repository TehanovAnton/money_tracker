# frozen_string_literal: true

require 'rails_helper'

describe Telegram::Messages::Layouts::Spreadsheets::AbstractFactories::AbstractFactory do
  subject { described_class.new(factory_name: factory_name, parsed_input: parsed_input) }

  let(:factory_name) { 'test_factory' }
  let(:parsed_input) { { key: 'value' } }

  describe '#validate_required_params' do
    context 'when factory_name is provided' do
      it 'does not add error' do
        subject.validate_required_params
        expect(subject.errors).to be_empty
      end
    end

    context 'when factory_name is not provided' do
      let(:factory_name) { nil }

      it 'adds error' do
        subject.validate_required_params
        expect(subject.errors[:factory_name]).to include('must be provided')
      end
    end
  end

  describe '#log_factory_creation' do
    it 'logs factory creation' do
      expect(Rails.logger).to receive(:debug).with("[AbstractFactory] Creating test_type for: test_factory")
      subject.log_factory_creation('test_type', 'test_factory')
    end
  end
end

describe Telegram::Messages::Layouts::Spreadsheets::AbstractFactories::ConcreteFactory do
  subject { described_class }

  describe '.input_parser_factory' do
    let(:factory_name) { 'date_input' }

    context 'when factory creation succeeds' do
      before do
        allow(Telegram::Messages::Layouts::Spreadsheets::Parsers::InputParserFactory)
          .to receive(:run!).with(factory_name: factory_name, style: :initializer)
          .and_return(double('input_parser'))
      end

      it 'creates input parser factory' do
        expect(Rails.logger).to receive(:debug).with("[ConcreteFactory] Creating InputParserFactory for: #{factory_name}")
        result = subject.input_parser_factory(factory_name)
        expect(result).not_to be_nil
      end
    end

    context 'when factory creation fails' do
      before do
        allow(Telegram::Messages::Layouts::Spreadsheets::Parsers::InputParserFactory)
          .to receive(:run!).and_raise('Factory creation failed')
      end

      it 'raises error with descriptive message' do
        expect(Rails.logger).to receive(:error)
        expect { subject.input_parser_factory(factory_name) }
          .to raise_error('Unable to create input parser factory for date_input')
      end
    end
  end

  describe '.text_preparation_factory' do
    let(:factory_name) { 'date_input' }

    context 'when factory creation succeeds' do
      before do
        allow(Telegram::Messages::Layouts::Spreadsheets::Support::TextPreparationFactory)
          .to receive(:run!).with(factory_name: factory_name, style: :initializer)
          .and_return(double('text_preparation'))
      end

      it 'creates text preparation factory' do
        expect(Rails.logger).to receive(:debug).with("[ConcreteFactory] Creating TextPreparationFactory for: #{factory_name}")
        result = subject.text_preparation_factory(factory_name)
        expect(result).not_to be_nil
      end
    end

    context 'when factory creation fails' do
      before do
        allow(Telegram::Messages::Layouts::Spreadsheets::Support::TextPreparationFactory)
          .to receive(:run!).and_raise('Factory creation failed')
      end

      it 'raises error with descriptive message' do
        expect(Rails.logger).to receive(:error)
        expect { subject.text_preparation_factory(factory_name) }
          .to raise_error('Unable to create text preparation factory for date_input')
      end
    end
  end

  describe '.layout_params_factory' do
    let(:factory_name) { 'date_input' }
    let(:parsed_input) { { date: '2026-01-01' } }

    context 'when factory creation succeeds' do
      let(:layout_params_factory) { double('layout_params_factory') }

      before do
        allow(Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsFactory)
          .to receive(:run!).with(factory_name: factory_name, style: :initializer)
          .and_return(layout_params_factory)
        allow(layout_params_factory).to receive(:tap).and_return(layout_params_factory)
      end

      it 'creates layout params factory with parsed input' do
        expect(Rails.logger).to receive(:debug).with("[ConcreteFactory] Creating LayoutParamsFactory for: #{factory_name}")
        result = subject.layout_params_factory(factory_name, parsed_input)
        expect(result).to eq(layout_params_factory)
      end
    end

    context 'when factory creation fails' do
      before do
        allow(Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsFactory)
          .to receive(:run!).and_raise('Factory creation failed')
      end

      it 'raises error with descriptive message' do
        expect(Rails.logger).to receive(:error)
        expect { subject.layout_params_factory(factory_name, parsed_input) }
          .to raise_error('Unable to create layout params factory for date_input')
      end
    end
  end
end