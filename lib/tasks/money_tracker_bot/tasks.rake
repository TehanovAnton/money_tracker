# frozen_string_literal: true

require 'telegram/bot'

namespace :money_tracker do
  desc 'Starts moeny traker bot'
  task start: :environment do
    token = Settings.app.telegram.bot.moeny_tracker_bot.token

    Telegram::Bot::Client.run(token) do |bot|
      puts 'Start bot'

      bot.listen do |message|
        TelegramLogger.log(message)

        user = User.find_or_create_by(telegram_username: message.from.username)
        output = Telegram::CommandMesageHandlerService.run!(user: user, message_text: message.text)
        chat_id = message.chat.id

        bot.api.send_message(chat_id: chat_id, text: output)
      end
    end
  end
end
