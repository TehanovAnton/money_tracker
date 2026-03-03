# frozen_string_literal: true

require 'rails_helper'

describe Telegram::Messages::Layouts::Spreadsheets::Layouts::DataActionsLayout do
  subject { described_class.run(user: user, bot: bot, **layout_inputs) }

  let(:message_text) { nil }
  let(:layout_inputs) { TelegramSpreadsheets.input_parsers(described_class).run!(text: message_text) }
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

    it 'runs add expense layout with spreadsheet from chat context' do
      FactoryBot.create(:chat_context, user_id: user.id, spreadsheet_id: spreadsheet.id)

      subject
      expect(AddExpenseLayout).to have_received(:run!).with(
        bot: bot,
        user: user,
        spreadsheet_id: spreadsheet.id,
        action_name: :list_all_actions
      )
    end

    context 'when user has multiple chat_context records' do
      let!(:another_spreadsheet) { FactoryBot.create(:spreadsheet, user: user, document_id: 'another-document-id') }

      it 'runs add expense layout with latest chat context spreadsheet' do
        FactoryBot.create(:chat_context, user_id: user.id, spreadsheet_id: spreadsheet.id, updated_at: 1.day.ago)
        FactoryBot.create(
          :chat_context, user_id: user.id, spreadsheet_id: another_spreadsheet.id, updated_at: Time.current
        )

        subject
        expect(AddExpenseLayout).to have_received(:run!).with(
          bot: bot,
          user: user,
          spreadsheet_id: another_spreadsheet.id,
          action_name: :list_all_actions
        )
      end
    end
  end
end
