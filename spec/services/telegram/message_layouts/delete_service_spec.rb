# frozen_string_literal: true

require 'rails_helper'

describe Telegram::MessageLayouts::DeleteService do
  subject { described_class.run(user: user, bot: bot, **layout_inputs) }

  let(:layout_inputs) { { action_name: action_name, document_id: document_id } }
  let(:messages) { subject.result }
  let(:user) { FactoryBot.create(:user, :with_layout_cursor_action) }
  let(:bot) { Telegram::BotDecorator.new({}, nil) }
  let!(:spreadsheet) { FactoryBot.create(:spreadsheet, user: user) }
  let(:document_id) { spreadsheet.document_id }

  before do
    allow(bot).to receive(:send_message)
    allow(Index).to receive(:run!)
    allow(ListTables).to receive(:run!)
  end

  context 'when enter_spreadsheets_params with valid document_id' do
    let(:action_name) { :enter_spreadsheets_params }

    it do
      expect(subject).to be_valid
      expect(messages).to include('Таблица удалена')
      expect(Spreadsheet.where(user: user)).to be_empty
      expect(Index).to have_received(:run!)
    end
  end

  context 'when enter_spreadsheets_params with named document_id' do
    let(:action_name) { :enter_spreadsheets_params }
    let(:document_id) { "--document_id #{spreadsheet.document_id}" }

    it do
      expect(subject).to be_valid
      expect(messages).to include('Таблица удалена')
      expect(Spreadsheet.where(user: user)).to be_empty
      expect(Index).to have_received(:run!)
    end
  end

  context 'when enter_spreadsheets_params with long-dash named and quoted document_id' do
    let(:action_name) { :enter_spreadsheets_params }
    let(:document_id) { "—document_id \"#{spreadsheet.document_id}\"" }

    it do
      expect(subject).to be_valid
      expect(messages).to include('Таблица удалена')
      expect(Spreadsheet.where(user: user)).to be_empty
      expect(Index).to have_received(:run!)
    end
  end

  context 'when enter_spreadsheets_params with empty document_id' do
    let(:action_name) { :enter_spreadsheets_params }
    let(:document_id) { nil }

    it do
      expect(subject).to be_valid
      expect(messages).to include('Невалидные данные таблицы')
      expect(Spreadsheet.where(user: user)).to exist
    end
  end
end
