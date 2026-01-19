# frozen_string_literal: true

module Telegram
  class LayoutInputParser < Parslet::Parser
    attr_reader :value_alias

    def initialize(value_alias = :input_value)
      @value_alias = value_alias
      super()
    end

    root(:expression)
    rule(:expression) { action_number >> input_value }

    rule(:action_number) { match('\d').repeat(1).as(:action_number) >> str(')') }
    rule(:input_value) { match('\w').repeat.as(value_alias) }
  end
end
