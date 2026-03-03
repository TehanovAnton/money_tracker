# frozen_string_literal: true

module Telegram
  class NewSpreadsheetInputParser < Parslet::Parser
    root(:value_input)

    rule(:value_input) do
      space >> action_number >> space >> document_id_parameter >> space >> expense_range_parameter >> space
    end

    rule(:action_number) { match('\d').repeat(1).as(:action_number) >> str(')') }

    rule(:document_id_parameter) do
      str('--document_id') >> space >> document_id_value
    end

    rule(:document_id_value) do
      (str('--expense_range').absent? >> any).repeat(1).as(:document_id)
    end

    rule(:expense_range_parameter) do
      str('--expense_range') >> space >> expense_range_value
    end

    rule(:expense_range_value) do
      quoted_value(:expense_range) | match('[^\s]').repeat(1).as(:expense_range)
    end

    rule(:space) { match('\s').repeat }

    def quoted_value(value_alias)
      (
        str('"') >> match('[^"]').repeat(1).as(value_alias) >> str('"')
      ) | (
        str("'") >> match("[^']").repeat(1).as(value_alias) >> str("'")
      )
    end
  end
end
