# frozen_string_literal: true

module Telegram
  class MessageHandler < ActiveInteraction::Base
    object :bot, class: BotDecorators::BotDecorator

    def execute
      layout_messages = \
        if layout_cursor_action
          layout.run(bot: bot, user: user, **layout_inputs)
                .messages
        elsif bot.message_text == '/start'
          layouts_factory(layout_name: :index).run!(bot: bot, user: user)
        else
          "Здравствуйте #{user.telegram_username}. Начните работу командой /start"
        end
      return unless layout_messages&.any?

      layout_messages.each { |message| bot.send_message(message) }
    end

    private

    def layout_inputs
      Messages::Layouts::Spreadsheets
        .input_parsers(layout)
        .run!(text: bot.message_text)
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

    def messages
      @messages ||= []
    end

    def layouts_factory(layout_name:)
      ::Telegram::Messages::Layouts::Spreadsheets::LayoutsFactory.run!(layout_name: layout_name)
    end
  end
end
