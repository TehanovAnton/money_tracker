# frozen_string_literal: true

require 'rails_helper'

describe Telegram::Messages::Layouts::Spreadsheets::AddExpenseLayout do
  subject { described_class.run(user: user, bot: bot, **layout_inputs, **chat_context_inputs) }

  let(:message_text) { nil }
  let(:layout_inputs) do
    Spreadsheets.input_parsers(described_class).run!(text: message_text)
  end
  let(:chat_context_inputs) do
    { spreadsheet_id: chat_context.spreadsheet_id }
  end
  let(:messages) { subject.result }
  let(:user) { FactoryBot.create(:user, :with_layout_cursor_action) }
  let(:bot) { Telegram::BotDecorators::BotDecorator.new({}, nil) }

  let(:action_name) { nil }
  let(:action_number) { described_class.action_number_for(action_name) }

  let!(:spreadsheet) { FactoryBot.create(:spreadsheet, user: user) }
  let(:chat_context) do
    FactoryBot.create(:chat_context, user: user, spreadsheet_id: spreadsheet.id)
  end
  let(:spreadsheet_form) { SpreadsheetForm.find_by(user: user, spreadsheet_id: spreadsheet.id) }

  before do
    allow(bot).to receive(:send_message)
  end

  context 'when enter_date' do
    let(:action_name) { :enter_date }
    let(:message_text) { "#{action_number}) 01.01.2026" }
    let(:date_form_input) { DateFormInput.find_by(form_id: spreadsheet_form.id) }

    it do
      subject
      expect(spreadsheet_form).to be_valid
      expect(date_form_input.date).to eq('01.01.2026')
    end
  end

  context 'when enter_money' do
    let(:action_name) { :enter_money }
    let(:message_text) { "#{action_number}) 2.75" }
    let(:money_form_input) { MoneyFormInput.find_by(form_id: spreadsheet_form.id) }

    it do
      subject
      expect(spreadsheet_form).to be_valid
      expect(money_form_input.money).to eq(2.75)
    end
  end
end
