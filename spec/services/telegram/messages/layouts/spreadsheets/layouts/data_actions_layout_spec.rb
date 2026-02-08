# frozen_string_literal: true

require 'rails_helper'

describe Telegram::Messages::Layouts::Spreadsheets::Layouts::DataActionsLayout do
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

  context 'when add_expense' do
    let(:action_name) { :add_expense }
    let!(:spreadsheet) { FactoryBot.create(:spreadsheet, user: user) }
    let!(:chat_context) { FactoryBot.create(:chat_context, user_id: user.id, spreadsheet_id: spreadsheet.id) }
    let(:message_text) { action_number.to_s }

    before do
      allow(AddExpenseLayout).to receive(:run!)
    end

    it do
      subject
      expect(AddExpenseLayout).to have_received(:run!)
    end
  end
end
