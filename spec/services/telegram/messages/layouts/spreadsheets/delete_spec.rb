# frozen_string_literal: true

require 'rails_helper'

Index = Telegram::Messages::Layouts::Spreadsheets::Index

describe Telegram::Messages::Layouts::Spreadsheets::Delete do
  subject { described_class.run(user: user, bot: bot, action_number: action_number, spreadsheet_id: spreadsheet_id) }

  let(:messages) { subject.result }
  let(:user) { FactoryBot.create(:user, :with_layout_cursor_action) }
  let(:action_number) { 0 }
  let(:bot) { Telegram::BotDecorators::BotDecorator.new({}, nil) }
  let!(:spreadsheet) { FactoryBot.create(:spreadsheet, user: user) }
  let(:spreadsheet_id) { spreadsheet.spreadsheet_id }

  before do
    allow(bot).to receive(:send_message)
    allow(Index).to receive(:run!)
  end

  context 'when delete_table' do
    it do
      expect(subject).to be_valid
      expect(Spreadsheet.where(user: user)).to be_empty
      expect(Index).to have_received(:run!)
    end
  end
end
