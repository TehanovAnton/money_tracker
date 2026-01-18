# frozen_string_literal: true

require 'rails_helper'

Index = Telegram::Messages::Layouts::Spreadsheets::Index

describe Telegram::Messages::Layouts::Spreadsheets::New do
  subject do
    described_class.run(user: user, bot: bot, action_number: action_number, spreadsheet_id: spreadsheet_id)
  end

  let(:bot) { Telegram::BotDecorators::BotDecorator.new({}, nil) }
  let(:user) { FactoryBot.create(:user, :with_layout_cursor_action) }
  let(:spreadsheet_id) { nil }
  let(:action_number) { '0' }

  before do
    allow(bot).to receive(:send_message)
  end

  context 'when list_all_actions' do
    it do
      subject

      user.reload
      expect(user.layout_cursor_action.layout).to eq(described_class.name)
      expect(user.layout_cursor_action.action).to eq('list_all_actions')
    end
  end

  context 'when enter_spreadsheet_id' do
    let(:action_number) { '1' }
    let(:spreadsheet_id) { 'fghjklkjhgfgh' }
    let(:spreadsheet) { Spreadsheet.find_by(user_id: user) }

    before do
      allow(Index).to receive(:run!)
    end

    it do
      subject
      expect(spreadsheet).to be_present
      expect(Index).to have_received(:run!)
    end
  end
end
