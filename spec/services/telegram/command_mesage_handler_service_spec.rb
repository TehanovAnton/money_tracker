# frozen_string_literal: true

require 'rails_helper'

describe Telegram::CommandMesageHandlerService do
  subject(:result) { described_class.run!(user: user, message_text: text) }

  let(:user) { FactoryBot.create(:user) }

  describe '/spreadsheets --add_expense command' do
    let(:document_id) { 'test-doc-id' }
    let!(:spreadsheet) { FactoryBot.create(:spreadsheet, user: user, document_id: document_id) }
    let(:rest_balance) { '5000.0' }
    let(:base_text) do
      %(spreadsheets
        --add_expense --document_id="#{document_id}" --date="17.05.2026" --amount="100" --category="Продукты"
      )
    end

    before do
      allow(Telegram::Commands::Spreadsheets::UpsertExpenseService).to receive(:run!)
    end

    context 'when --show_rest_balance flag is present' do
      let(:text) { "/#{base_text} --show_rest_balance" }

      before do
        allow(Telegram::Commands::Spreadsheets::UpsertExpenseService).to receive(:run!).and_return(true)
        allow(Telegram::Commands::Spreadsheets::DocumentRestBalanceService)
          .to receive(:run!)
          .with(document_id: document_id, cell: spreadsheet.rest_balance_cell)
          .and_return(rest_balance)
      end

      it 'includes rest_balance in response' do
        expect(result).to include("Остаток: #{rest_balance}")
      end
    end
  end

  describe '/spreadsheets --add command' do
    describe 'success cases' do
      let(:text) { '/spreadsheets --add --document_id="new-doc" --expense_range="Sheet1!A1:B1"' }
      let(:new_spreadsheet) { user.spreadsheets.last }

      it do
        expect(result.class).to be(String)
        expect(new_spreadsheet).to be_valid
      end
    end
  end
end
