# frozen_string_literal: true

require 'rails_helper'

describe ::Spreadsheets::ParamsBuilder do
  subject(:built_params) { described_class.run!(spreadsheet_form: spreadsheet_form) }

  let(:range_value) { 'Sheet1!A:D' }
  let(:date_value) { '01.01.2026' }
  let(:money_value) { 250.75 }
  let(:category_value) { 'Food' }
  let(:comment_value) { 'Lunch' }
  let(:user) { FactoryBot.create(:user) }
  let(:spreadsheet) { FactoryBot.create(:spreadsheet, user: user, document_id: 'document-id') }
  let(:spreadsheet_form) { FactoryBot.create(:spreadsheet_form, user: user, spreadsheet: spreadsheet) }

  let!(:range_form_input) { RangeFormInput.create!(form_id: spreadsheet_form.id, range: range_value) }
  let!(:date_form_input) { DateFormInput.create!(form_id: spreadsheet_form.id, date: date_value) }
  let!(:money_form_input) { MoneyFormInput.create!(form_id: spreadsheet_form.id, money: money_value) }
  let!(:category_form_input) { CategoryFormInput.create!(form_id: spreadsheet_form.id, category: category_value) }
  let!(:comment_form_input) { CommentFormInput.create!(form_id: spreadsheet_form.id, comment: comment_value) }

  context 'when required inputs are present' do
    let(:expected_result) do
      {
        document_id: 'document-id',
        sheet: {
          range: range_value,
          values: [['01.01.2026', BigDecimal('250.75'), 'Food', 'Lunch']]
        }
      }
    end

    it 'returns typed payload hash' do
      expect(built_params.to_h).to eq(expected_result)
    end
  end

  context 'when required input is missing' do
    let(:money_value) { nil }

    it 'raises no value error' do
      expect { built_params }.to raise_error(described_class::NoValueError)
    end
  end
end
