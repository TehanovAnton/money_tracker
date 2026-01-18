# frozen_string_literal: true

module Telegram
  module BotDecorators
    class BotDecorator < Base
      attr_reader :message

      def initialize(bot, message)
        @message = message
        super(bot)
      end

      delegate :text, to: :message, prefix: true

      def send_message(text)
        api.send_message(chat_id: message.chat.id, text: text)
      end

      def username
        message.from.username
      end
    end
  end
end
