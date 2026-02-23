# frozen_string_literal: true

require 'rails_helper'

describe Telegram::Messages::Layouts::Spreadsheets::Layouts::DataActionsLayout do
  subject { described_class.run(user: user, bot: bot, **layout_inputs) }

  let(:message_text) { nil }
  let(:expense_data_input) { :field_by_field }
  let(:layout_inputs) do
    TelegramSpreadsheets.input_parsers(described_class).run!(text: message_text).merge(
      expense_data_input: expense_data_input
    )
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
    let(:message_text) { action_number.to_s }

    before do
      allow(AddExpenseLayout).to receive(:run!)
    end

    it 'runs default field-by-field layout' do
      FactoryBot.create(:chat_context, user_id: user.id, spreadsheet_id: spreadsheet.id)

      subject
      expect(AddExpenseLayout).to have_received(:run!)
    end

    context 'when expense_data_input is unsupported' do
      let(:expense_data_input) { :single_message }

      it 'raises an argument error' do
        FactoryBot.create(:chat_context, user_id: user.id, spreadsheet_id: spreadsheet.id)

        expect { subject }.to raise_error(ArgumentError, 'Unknown expense_data_input: single_message')
      end
    end
  end
end
