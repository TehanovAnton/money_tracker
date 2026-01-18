# frozen_string_literal: true

module Telegram
  class MessageHandler < ActiveInteraction::Base
    object :bot, class: BotDecorators::BotDecorator

    def execute
      if layout_cursor_action
        layout.run!(bot: bot, user: user, action_number: action)
      elsif bot.message_text == '/start'
        Telegram::Messages::Layouts::Spreadsheets::Index.run!(bot: bot, user: user)
      else
        text = "Здравствуйте #{user.telegram_username}. Начните работу командой /start"
        bot.send_message(text)
      end
    end

    private

    def layout_cursor_action
      @layout_cursor_action ||= user.layout_cursor_action
    end

    def layout
      layout_cursor_action.layout.constantize
    end

    def action
      bot.message_text
    end

    def user
      @user ||= User.find_or_create_by(telegram_username: bot.username)
    end
  end
end
