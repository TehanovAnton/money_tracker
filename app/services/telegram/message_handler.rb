# frozen_string_literal: true

module Telegram
  class MessageHandler < ActiveInteraction::Base
    object :bot, class: BotDecorators::BotDecorator

    def execute
      messages = \
        if layout_cursor_action
          layout.run!(bot: bot, user: user, **layout_inputs)
        elsif bot.message_text == '/start'
          Telegram::Messages::Layouts::Spreadsheets::Index.run!(bot: bot, user: user)
        else
          "Здравствуйте #{user.telegram_username}. Начните работу командой /start"
        end

      return unless messages&.any?

      messages.each { |message| bot.send_message(message) }
    end

    private

    def layout_inputs
      return { action_number: bot.message_text } unless layout.may_receive_inputs?

      layout
        .inputs_parser
        .new
        .parse(bot.message_text.gsub(/\s/, ''))
        .transform_values(&:to_s)
    end

    def layout_cursor_action
      @layout_cursor_action ||= user.layout_cursor_action
    end

    def layout
      layout_cursor_action.layout.constantize
    end

    def user
      @user ||= User.find_or_create_by(telegram_username: bot.username)
    end
  end
end
