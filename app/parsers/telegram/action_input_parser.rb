# frozen_string_literal: true

module Telegram
  class ActionInputParser < Parslet::Parser
    root(:expression)
    rule(:expression) { action_number }

    rule(:action_number) { match('\d').repeat(1).as(:action_number) }
  end
end
