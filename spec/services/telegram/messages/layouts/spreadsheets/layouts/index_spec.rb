# frozen_string_literal: true

require 'rails_helper'

describe Telegram::Messages::Layouts::Spreadsheets::Layouts::Index do
  subject { described_class.run(user: user, bot: bot, **layout_inputs) }

  let(:action_number) { described_class.action_number_for(action_name) }

  let(:layout_inputs) do
    TelegramSpreadsheets.input_parsers(described_class).run!(text: message_text, layout_klass: described_class.name)
  end
  let(:messages) { subject.result }
  let(:user) { FactoryBot.create(:user, :with_layout_cursor_action) }
  let(:bot) { Telegram::Bot::BotDecorator.new({}, nil) }

  before do
    allow(bot).to receive(:send_message)
  end

  context 'when list_all_actions' do
    let(:message_text) { action_number.to_s }
    let(:action_name) { :list_all_actions }

    it do
      expect(subject).to be_valid
      expect(user.layout_cursor_action.layout).to eq(described_class.name)
      expect(messages).to include(subject.send(:list_actions_text))
    end
  end

  context 'when list_tables' do
    let(:action_name) { :list_tables }

    let!(:spreadsheet) { FactoryBot.create(:spreadsheet, user: user) }
    let(:message_text) { action_number.to_s }
    let(:spreadsheet_text_line) { "1) #{spreadsheet.document_id}" }

    it do
      subject
      expect(messages).to include(spreadsheet_text_line)
    end
  end

  context 'when add_table' do
    let(:action_name) { :add_table }
    let(:message_text) { action_number.to_s }

    before do
      allow(New).to receive(:run!)
    end

    it do
      expect(subject).to be_valid
      expect(New).to have_received(:run!)
    end
  end
end
