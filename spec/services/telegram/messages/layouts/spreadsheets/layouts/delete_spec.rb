# frozen_string_literal: true

require 'rails_helper'

describe Telegram::Messages::Layouts::Spreadsheets::Layouts::Delete do
  subject { described_class.run(user: user, bot: bot, action_number: action_number, document_id: document_id) }

  let(:action_number) { described_class.action_number_for(action_name) }

  let(:messages) { subject.result }
  let(:user) { FactoryBot.create(:user, :with_layout_cursor_action) }
  let(:bot) { Telegram::BotDecorators::BotDecorator.new({}, nil) }
  let!(:spreadsheet) { FactoryBot.create(:spreadsheet, user: user) }
  let(:document_id) { spreadsheet.document_id }

  before do
    allow(bot).to receive(:send_message)
    allow(Index).to receive(:run!)
  end

  context 'when delete_table' do
    let(:action_name) { :delete_table }

    it do
      expect(subject).to be_valid
      expect(Spreadsheet.where(user: user)).to be_empty
      expect(Index).to have_received(:run!)
    end
  end
end
