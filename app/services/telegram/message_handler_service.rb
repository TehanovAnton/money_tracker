# frozen_string_literal: true

module Telegram
  ActionParser = Struct.new(:text) do
    def action
      headers_decorator.action[:value].to_s
    end

    def headers_decorator
      @headers_decorator ||= HeadersDecorator.new(
        HeadersParser.new.parse(text)
      )
    end
  end

  BodyParser = Struct.new(:text) do
    def message_body_decorator
      MessageBodyDecorator.new(::BodyParser.new.parse(text))
    end
  end

  class MessageHandlerService < ActiveInteraction::Base
    include Dry::Monads[:maybe]

    ACTIONS = { upsert: 'upsert', unknown: 'unknown' }.freeze

    string :message_text
    integer :chat_id
    object :bot, class: Telegram::Bot::Client

    def execute
      case action_parser.action
      when ACTIONS[:upsert]
        Spreadsheets::UpsertService.run!(params: spreadsheet_upsert_params)
      when ACTIONS[:unknown]
        # ignore
      end

      bot_api.send_message(chat_id: chat_id, text: 'Everythigs went ok')
    rescue StandardError => _e
      bot_api.send_message(chat_id: chat_id, text: 'Something went wrong')
    end

    private

    def bot_api
      @bot_api ||= bot.api
    end

    def text_parts
      @text_parts ||= message_text.split('#===')
    end

    def action_parser
      @action_parser ||= ActionParser.new(text_parts.first)
    end

    def body_parser
      @body_parser ||= BodyParser.new(text_parts.last.strip).message_body_decorator
    end

    def spreadsheet_upsert_params
      {
        spreadsheet_id: body_parser.spreadsheet_id,
        sheet: {
          range: body_parser.sheet_range,
          values: [
            [
              body_parser.date,
              body_parser.money,
              body_parser.category,
              body_parser.comment
            ]
          ]
        }
      }
    end
  end
end
