# frozen_string_literal: true

require 'rails_helper'

describe Telegram::Commands::Spreadsheets::AddExpenseService do
  subject(:result) do
    described_class.run!(
      user: user,
      document_id: document_id,
      expense_data: expense_data
    )
  end

  let(:user) { FactoryBot.create(:user) }
  let(:spreadsheet) { FactoryBot.create(:spreadsheet, user: user) }
  let(:document_id) { spreadsheet.document_id }
  let(:expense_data) { FactoryBot.build(:expense_type) }

  before do
    allow(Telegram::Commands::Spreadsheets::UpsertExpenseService).to receive(:run!)
  end

  shared_examples 'render view' do |args|
    before do
      allow(ApplicationController).to receive(:render)
        .with(hash_including(template: args[:template])).once
        .and_return('Ok')
    end

    it do
      expect(result.class).to eq(String)
    end
  end

  describe 'success cases' do
    it_behaves_like 'render view', template: 'telegram/commands/spreadsheets/add_expense/success'
  end

  describe 'fail cases' do
    shared_context 'when unkonwn document_id' do
      let(:document_id) { 'unknown' }
    end

    shared_context 'when spreadsheet of other user' do
      let(:spreadsheet) { FactoryBot.create(:spreadsheet) }
      let(:document_id) { spreadsheet.document_id }
    end

    shared_context 'when invalid expense' do
      let(:expense_data) { FactoryBot.build(:expense_type, amount: '-100') }
    end

    shared_examples 'render view scenarios' do |args|
      args[:scenarios].each do |scenario|
        context scenario[:name] do
          include_context scenario[:context]

          it_behaves_like 'render view', template: scenario[:template]
        end
      end
    end

    it_behaves_like 'render view scenarios', scenarios: [
      {
        name: 'when unknonw spreadsheet',
        context: 'when unkonwn document_id',
        template: 'telegram/commands/spreadsheets/add_expense/could_not_find_spreadsheet'
      },
      {
        name: 'when spreadsheet of other user',
        context: 'when spreadsheet of other user',
        template: 'telegram/commands/spreadsheets/add_expense/could_not_find_spreadsheet'
      },
      {
        name: 'when invlaid expense',
        context: 'when invalid expense',
        template: 'telegram/commands/spreadsheets/add_expense/invalid_record'
      }
    ]
  end
end
