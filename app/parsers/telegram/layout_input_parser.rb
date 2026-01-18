# frozen_string_literal: true

module Telegram
  class LayoutInputParser < Parslet::Parser
    root(:expression)
    rule(:expression) { action_number >> input_value }

    rule(:action_number) { match('\d').repeat(1).as(:action_number) >> str(')') }
    rule(:input_value) { match('\w').repeat.as(:input_value) }
  end
end
