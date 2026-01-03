# frozen_string_literal: true

require 'telegram/bot'

namespace :money_tracker do
  desc 'Starts moeny traker bot'
  task start: :environment do
    token = Settings.app.telegram.bot.moeny_tracker_bot.token

    Telegram::Bot::Client.run(token) do |bot|
      puts 'Start bot'

      bot.listen do |message|
        Telegram::MessageHandlerService.run!(bot: bot, message_text: message.text, chat_id: message.chat.id)
      end
    end
  end
end
