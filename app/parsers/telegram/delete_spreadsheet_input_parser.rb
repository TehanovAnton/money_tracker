# frozen_string_literal: true

module Telegram
  class DeleteSpreadsheetInputParser < Parslet::Parser
    root(:value_input)

    rule(:value_input) do
      space >> action_number >> space >> document_id_parameter >> space
    end

    rule(:action_number) { match('\d').repeat(1).as(:action_number) >> str(')') }

    rule(:document_id_parameter) do
      str('--document_id') >> space >> document_id_value
    end

    rule(:document_id_value) do
      quoted_value(:document_id) | match('[^\s]').repeat(1).as(:document_id)
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
