# frozen_string_literal: true

require 'telegram/bot'

namespace :money_tracker do
  desc 'Starts moeny traker bot'
  task start: :environment do
    token = Settings.app.telegram.bot.moeny_tracker_bot.token

    Telegram::Bot::Client.run(token) do |bot|
      puts 'Start bot'

      bot.listen do |message|
        if message.text == '/start'
          
        end
      end
    end
  end
end
