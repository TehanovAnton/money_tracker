# frozen_string_literal: true

require 'rails_helper'

describe Telegram::Messages::Layouts::Spreadsheets::ListTables do
  subject { described_class.run(user: user, bot: bot, **layout_inputs) }

  let(:message_text) { nil }
  let(:layout_inputs) do
    Spreadsheets.input_parsers(described_class).run!(text: message_text)
  end
  let(:messages) { subject.result }
  let(:user) { FactoryBot.create(:user, :with_layout_cursor_action) }
  let(:bot) { Telegram::BotDecorators::BotDecorator.new({}, nil) }

  let(:action_name) { nil }
  let(:action_number) { described_class.action_number_for(action_name) }

  before do
    allow(bot).to receive(:send_message)
  end

  context 'when list_all_actions' do
    let(:action_name) { :list_all_actions }
    let(:message_text) { action_number.to_s }

    it do
      expect(subject).to be_valid
      expect(user.layout_cursor_action.layout).to eq(described_class.name)
      expect(messages).to include(subject.send(:list_actions_text))
    end
  end

  context 'when list_tables' do
    let!(:spreadsheet) { FactoryBot.create(:spreadsheet, user: user) }
    let(:action_name) { :list_tables }
    let(:message_text) { action_number.to_s }
    let(:spreadsheet_text_line) { "1) #{spreadsheet.document_id}" }

    it do
      subject
      expect(messages).to include(spreadsheet_text_line)
    end
  end

  context 'when delete_table' do
    let!(:spreadsheet) { FactoryBot.create(:spreadsheet, user: user) }
    let(:action_name) { :delete_table }
    let(:message_text) { "#{action_number}) #{spreadsheet.document_id}" }

    before do
      allow(Delete).to receive(:run!)
    end

    it do
      subject
      expect(Delete).to have_received(:run!)
    end
  end

  context 'when data_actions' do
    let!(:spreadsheet) { FactoryBot.create(:spreadsheet, user: user) }
    let(:action_name) { :data_actions }
    let(:message_text) { "#{action_number}) #{spreadsheet.document_id}" }

    before do
      allow(DataActionsLayout).to receive(:run!)
    end

    it do
      subject
      expect(DataActionsLayout).to have_received(:run!)
    end
  end
end
