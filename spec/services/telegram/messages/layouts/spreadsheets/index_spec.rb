# frozen_string_literal: true

require 'rails_helper'

New = Telegram::Messages::Layouts::Spreadsheets::New
Delete = Telegram::Messages::Layouts::Spreadsheets::Delete

describe Telegram::Messages::Layouts::Spreadsheets::Index do
  subject { described_class.run(user: user, bot: bot, action_number: action_number) }

  let(:messages) { subject.result }
  let(:user) { FactoryBot.create(:user, :with_layout_cursor_action) }
  let(:action_number) { 0 }
  let(:bot) { Telegram::BotDecorators::BotDecorator.new({}, nil) }

  before do
    allow(bot).to receive(:send_message)
  end

  context 'when list_all_actions' do
    it do
      expect(subject).to be_valid
      expect(user.layout_cursor_action.layout).to eq(described_class.name)
      expect(messages).to include(subject.send(:list_actions_text))
    end
  end

  context 'when list_tables' do
    let!(:spreadsheet) { FactoryBot.create(:spreadsheet, user: user) }
    let(:action_number) { '1' }
    let(:spreadsheet_text_line) { "1) #{spreadsheet.spreadsheet_id}" }

    it do
      subject
      expect(messages).to include(spreadsheet_text_line)
    end
  end

  context 'when add_table' do
    let(:action_number) { '2' }

    before do
      allow(New).to receive(:run!)
    end

    it do
      expect(subject).to be_valid
      expect(New).to have_received(:run!)
    end
  end

  context 'when delete_action_table' do
    let(:action_number) { '3' }

    before do
      allow(Delete).to receive(:run!)
    end

    it do
      subject
      expect(Delete).to have_received(:run!)
    end
  end
end
