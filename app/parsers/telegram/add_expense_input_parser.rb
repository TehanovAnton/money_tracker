# frozen_string_literal: true

module Telegram
  class AddExpenseInputParser < Parslet::Parser
    attr_reader :value_alias, :kind

    def initialize(value_alias = :input_value, kind:)
      @value_alias = value_alias
      @kind = kind
      super()
    end

    root(:expression)
    rule(:expression) { action_number >> input_value }

    rule(:action_number) { match('\d').repeat(1).as(:action_number) >> str(')') }

    rule(:input_value) do
      case kind
      when :date_input
        date_input
      when :money_input
        money_input
      when :category_input, :comment_input
        quoted_input
      end
    end

    rule(:money_input) do
      (match('\d').repeat(1, 4) >> float_part.maybe).as(value_alias)
    end

    rule(:float_part) do
      str('.') >> match('\d').repeat(nil, 2)
    end

    rule(:date_input) do
      (match('\d').repeat(2) >> str('.') >>
      match('\d').repeat(2) >> str('.') >>
      match('\d').repeat(4)).as(value_alias)
    end

    rule(:quoted_input) do
      match('\s').maybe >>
        str("'") >>
        match("[^']").repeat.as(value_alias) >>
        str("'")
    end
  end
end
