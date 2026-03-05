# frozen_string_literal: true

require 'rails_helper'

describe Telegram::MessageLayouts::AddExpenseLayout do
  subject { described_class.run(user: user, bot: bot, **layout_inputs, **chat_context_inputs) }

  let(:message_text) { nil }
  let(:layout_inputs) do
    TelegramSpreadsheets::InputParsersFactory.run!(factory_name: :add_expense).run!(text: message_text)
  end
  let(:chat_context_inputs) do
    { spreadsheet_id: chat_context.spreadsheet_id }
  end
  let(:messages) { subject.result }
  let(:user) { FactoryBot.create(:user, :with_layout_cursor_action) }
  let(:bot) { Telegram::BotDecorator.new({}, nil) }

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

  context 'when enter_category' do
    let(:action_name) { :enter_category }
    let(:message_text) { "#{action_number}) 'Домашний интернет'" }
    let(:category_form_input) { CategoryFormInput.find_by(form_id: spreadsheet_form.id) }

    it do
      subject
      expect(spreadsheet_form).to be_valid
      expect(category_form_input.category).to eq('Домашний интернет')
    end
  end

  context 'when enter_comment' do
    let(:action_name) { :enter_comment }
    let(:message_text) { "#{action_number}) 'Купил тапки'" }
    let(:comment_form_input) { CommentFormInput.find_by(form_id: spreadsheet_form.id) }

    it do
      subject
      expect(spreadsheet_form).to be_valid
      expect(comment_form_input.comment).to eq('Купил тапки')
    end
  end

  context 'when enter_all with valid params and comment' do
    let(:action_name) { :enter_all }
    let(:message_text) do
      "#{action_number}) --date 01.02.2026 --money 12.01 --category \"Продукты\" --comment \"за хлеб\""
    end
    let(:upsert_result) { instance_double(::Spreadsheets::UpsertService, valid?: true) }
    let(:date_form_input) { DateFormInput.find_by(form_id: spreadsheet_form.id) }
    let(:money_form_input) { MoneyFormInput.find_by(form_id: spreadsheet_form.id) }
    let(:category_form_input) { CategoryFormInput.find_by(form_id: spreadsheet_form.id) }
    let(:comment_form_input) { CommentFormInput.find_by(form_id: spreadsheet_form.id) }

    before do
      allow(::Spreadsheets::UpsertService).to receive(:run).and_return(upsert_result)
    end

    it 'creates all form inputs and publishes expense' do
      expect(messages).to include('Расход опубликован')
      expect(date_form_input.date).to eq('01.02.2026')
      expect(money_form_input.money).to eq(12.01)
      expect(category_form_input.category).to eq('Продукты')
      expect(comment_form_input.comment).to eq('за хлеб')
    end
  end

  context 'when enter_all with valid params without whitespaces and comment' do
    let(:action_name) { :enter_all }
    let(:message_text) do
      "#{action_number})--date01.02.2026--money12.01--category\"Продукты\""
    end
    let(:upsert_result) { instance_double(::Spreadsheets::UpsertService, valid?: true) }
    let(:date_form_input) { DateFormInput.find_by(form_id: spreadsheet_form.id) }
    let(:money_form_input) { MoneyFormInput.find_by(form_id: spreadsheet_form.id) }
    let(:category_form_input) { CategoryFormInput.find_by(form_id: spreadsheet_form.id) }
    let(:comment_form_input) { CommentFormInput.find_by(form_id: spreadsheet_form.id) }

    before do
      allow(::Spreadsheets::UpsertService).to receive(:run).and_return(upsert_result)
    end

    it 'creates required form inputs and publishes expense' do
      expect(messages).to include('Расход опубликован')
      expect(date_form_input.date).to eq('01.02.2026')
      expect(money_form_input.money).to eq(12.01)
      expect(category_form_input.category).to eq('Продукты')
      expect(comment_form_input).to be_nil
    end
  end

  context 'when enter_all with invalid params and empty date' do
    let(:action_name) { :enter_all }
    let(:message_text) { nil }
    let(:layout_inputs) do
      { action_number: action_number, date: nil, money: 12.01, category: 'Продукты', comment: 'за хлеб' }
    end

    before do
      allow(::Spreadsheets::ParamsBuilder).to receive(:run!)
    end

    it 'returns invalid date message' do
      subject
      expect(::Spreadsheets::ParamsBuilder).not_to have_received(:run!)
      expect(messages).to include('Пустая дата')
    end
  end

  context 'when enter_all with invalid params and empty category' do
    let(:action_name) { :enter_all }
    let(:message_text) { nil }
    let(:layout_inputs) do
      { action_number: action_number, date: '01.02.2026', money: 12.01, category: nil, comment: 'за хлеб' }
    end

    before do
      allow(::Spreadsheets::ParamsBuilder).to receive(:run!)
    end

    it 'returns invalid category message' do
      subject
      expect(::Spreadsheets::ParamsBuilder).not_to have_received(:run!)
      expect(messages).to include('Пустая категория')
    end
  end

  context 'when publish_expense and upsert is unsuccessful' do
    let(:action_name) { :publish_expense }
    let(:message_text) { action_number.to_s }
    let(:params_payload) do
      ::Spreadsheets::ParamsBuilder::Payload.new(
        document_id: 'document-id',
        sheet: ::Spreadsheets::ParamsBuilder::SheetPayload.new(
          range: 'Sheet1!A:D',
          values: [['01.01.2026', BigDecimal('250.75'), 'Food', 'Lunch']]
        )
      )
    end
    let(:upsert_result) { instance_double(::Spreadsheets::UpsertService, valid?: false) }

    before do
      allow(::Spreadsheets::ParamsBuilder).to receive(:run!).and_return(params_payload)
      allow(::Spreadsheets::UpsertService).to receive(:run).and_return(upsert_result)
    end

    it 'adds failure message for user' do
      expect(messages).to include('Не удалось опубликовать расход')
    end
  end
end
