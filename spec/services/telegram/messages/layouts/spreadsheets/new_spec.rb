# frozen_string_literal: true

require 'rails_helper'

Index = Telegram::Messages::Layouts::Spreadsheets::Index
Spreadsheets = Telegram::Messages::Layouts::Spreadsheets

describe Telegram::Messages::Layouts::Spreadsheets::New do
  subject do
    described_class.run(user: user, bot: bot, **layout_inputs)
  end

  let(:bot) { Telegram::BotDecorators::BotDecorator.new({}, nil) }
  let(:user) { FactoryBot.create(:user, :with_layout_cursor_action, layout: described_class) }
  let(:spreadsheet_id) { nil }
  let(:message_text) { '0' }
  let(:layout_inputs) do
    Spreadsheets.input_parsers(described_class).run!(text: message_text)
  end

  before do
    allow(bot).to receive(:send_message)
  end

  context 'when list_all_actions' do
    it do
      expect(subject).to be_valid
      user.reload
      expect(user.layout_cursor_action.layout).to eq(described_class.name)
    end
  end

  context 'when enter_spreadsheet_id' do
    let(:spreadsheet) { Spreadsheet.find_by(user_id: user) }
    let(:message_text) { '1)kjhjkpkjhhj' }

    before do
      allow(Index).to receive(:run!)
    end

    it do
      expect(subject).to be_valid
      expect(spreadsheet.spreadsheet_id).to eq(layout_inputs[:spreadsheet_id])
      expect(Index).to have_received(:run!)
    end
  end

  context 'when back_to_index' do
    let(:message_text) { '2' }
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
