# frozen_string_literal: true

require 'rails_helper'

TelegramApiStub = Struct.new do
  def send_message(*, **); end
end

describe Telegram::MessageHandlerService do
  subject(:handler) { described_class.run(bot: telegram_bot, message_text: message_text, chat_id: 1) }

  let(:token) { Settings.app.telegram.bot.moeny_tracker_bot.token }
  let(:telegram_bot) { Telegram::Bot::Client.run(token) { |bot| bot } }

  context 'when valid' do
    let(:message_text) do
      <<-TEXT
        method: post;
        action: upsert;
      #===
        body:
          spreadsheet_id: sadfasdflkasd;
          sheet_range: Октябрь!L30:N37;
          [#{expression}];
      TEXT
    end
    let(:expression) { '01.01.2025; 12,01; Продукты' }

    before do
      allow(telegram_bot).to receive(:api).and_return(TelegramApiStub.new)
      allow(Spreadsheets::UpsertService).to receive(:run!)
      # allow(Telegram::Bot::Api).to receive(:new).and_return(telegram_bot_api_stub)
    end

    it do
      handler

      expect(Spreadsheets::UpsertService).to have_received(:run!)
      expect(telegram_bot).to have_received(:api)
    end
  end
end
