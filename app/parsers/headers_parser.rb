# frozen_string_literal: true

class HeadersParser < Parslet::Parser
  include ParserHelper

  root(:expression)
  rule(:expression) do
    beginning >>
      message_method >>
      action
  end

  rule(:beginning) { str('^').repeat >> space? }
  rule(:message_method) { MethodParser.new.expression.as(:message_method) >> space? }
  rule(:action) { ActionParser.new.expression.as(:message_action) >> space? }
end
