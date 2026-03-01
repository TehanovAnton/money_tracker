# frozen_string_literal: true

require 'rails_helper'

describe Telegram::AddExpenseInputParser::Default do
  subject { described_class.new(kind: kind).parse(text) }

  context 'when date_input' do
    let(:text) { '2)01.01.2026' }
    let(:kind) { :date_input }

    it do
      expect { subject }.not_to raise_error
      expect(subject[:input_value].to_s).to eq('01.01.2026')
    end
  end

  context 'when money_input' do
    let(:text) { '3)2.75' }
    let(:kind) { :money_input }

    it do
      expect { subject }.not_to raise_error
      expect(subject[:input_value].to_s).to eq('2.75')
    end
  end

  context 'when category_input' do
    let(:text) { "3) 'Домашний интернет'" }
    let(:kind) { :category_input }

    it do
      expect { subject }.not_to raise_error
      expect(subject[:input_value].to_s).to eq('Домашний интернет')
    end
  end
end
