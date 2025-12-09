# frozen_string_literal: true

module TelegramBot
  class MessageParser < Parslet::Parser
    root(:message_expression)
    rule(:message_expression) do
      beginning >>
        message_method >>
        action >>
        body
    end

    rule(:beginning) { str('^').repeat >> space? }
    rule(:message_method) { MethodParser.new.expression.as(:message_action) >> space? }
    rule(:action) { ActionParser.new.expression.as(:message_action) >> space? }
    rule(:body) { BodyParser.new.expression.as(:message_body) }

    rule(:space) { match('\s').repeat(1) }
    rule(:space?) { space.maybe }
  end
end
