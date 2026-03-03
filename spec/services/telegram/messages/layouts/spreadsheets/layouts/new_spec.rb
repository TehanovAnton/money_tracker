# frozen_string_literal: true

require 'rails_helper'

describe Telegram::Messages::Layouts::Spreadsheets::Layouts::New do
  subject do
    described_class.run(user: user, bot: bot, **layout_inputs)
  end

  let(:action_number) { described_class.action_number_for(action_name) }

  let(:bot) { Telegram::BotDecorators::BotDecorator.new({}, nil) }
  let(:user) { FactoryBot.create(:user, :with_layout_cursor_action, layout: described_class) }
  let(:message_text) { action_number.to_s }
  let(:layout_inputs) do
    TelegramSpreadsheets.input_parsers(described_class).run!(text: message_text)
  end

  before do
    allow(bot).to receive(:send_message)
  end

  context 'when list_all_actions' do
    let(:action_name) { :list_all_actions }

    it do
      expect(subject).to be_valid
      user.reload
      expect(user.layout_cursor_action.layout).to eq(described_class.name)
    end
  end

  context 'when enter_spreadsheets_params with quoted expense_range' do
    let(:action_name) { :enter_spreadsheets_params }
    let(:spreadsheet) { Spreadsheet.find_by(user_id: user.id, document_id: 'spreadsheet-id') }
    let(:message_text) { "#{action_number}) --document_id spreadsheet-id --expense_range \"Sheet1!A1:B1\"" }

    before do
      allow(Index).to receive(:run!)
    end

    it do
      expect(subject).to be_valid
      expect(spreadsheet.document_id).to eq(layout_inputs[:document_id])
      expect(spreadsheet.expense_range).to eq(layout_inputs[:expense_range])
      expect(Index).to have_received(:run!)
    end
  end

  context 'when enter_spreadsheets_params with compact format' do
    let(:action_name) { :enter_spreadsheets_params }
    let(:spreadsheet) { Spreadsheet.find_by(user_id: user.id, document_id: 'spreadsheet-id') }
    let(:message_text) { "#{action_number})--document_idspreadsheet-id--expense_rangeSheet1!A1:B1" }

    before do
      allow(Index).to receive(:run!)
    end

    it do
      expect(subject).to be_valid
      expect(spreadsheet.document_id).to eq(layout_inputs[:document_id])
      expect(spreadsheet.expense_range).to eq(layout_inputs[:expense_range])
      expect(Index).to have_received(:run!)
    end
  end

  context 'when enter_spreadsheets_params with invalid format' do
    let(:action_name) { :enter_spreadsheets_params }
    let(:messages) { subject.result }
    let(:message_text) { "#{action_number}) --document_id spreadsheet-id" }

    it do
      expect(subject).to be_valid
      expect(messages).to include('Невалидные данные таблицы')
    end
  end

  context 'when back_to_index' do
    let(:action_name) { :back_to_index }
    let(:message_text) { action_number.to_s }
    let(:messages) { subject.send(:messages) }
    let(:index_list_actions_text) { Index.new(bot: bot, user: user).send(:list_actions_text) }

    it do
      expect(subject).to be_valid
      user.reload
      expect(user.layout_cursor_action.layout).to eq(Index.name)
      expect(messages).to include(index_list_actions_text)
    end
  end
end
