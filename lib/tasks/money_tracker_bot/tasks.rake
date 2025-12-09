# frozen_string_literal: true

require 'telegram/bot'

namespace :money_tracker do
  desc 'Starts moeny traker bot'
  task start: :environment do
    token = Settings.app.telegram.bot.moeny_tracker_bot.token

    Telegram::Bot::Client.run(token) do |bot|
      puts 'Start bot'

      bot.listen do |message|
        parsed_message = TelegramBot::MessageParser.new.parse(message.text)

        if parsed_message[:message_action][:value] == 'upsert'
          message_body = parsed_message[:message_body]
          upsert_params = {
            spreadsheet_id: message_body[:spreadsheet_id].to_s,
            sheet: {
              range: message_body[:sheet_range].to_s,
              values: [
                [
                  message_body[:date].to_s,
                  message_body[:money].to_s,
                  message_body[:category].to_s,
                  message_body.fetch(:comment, '').to_s
                ]
              ]
            }
          }

          Spreadsheets::UpsertService.run!(params: upsert_params)
        else
          bot.api.send_message(chat_id: message.chat.id, text: 'Unsupported action')
        end
      end
    end
  end
end
