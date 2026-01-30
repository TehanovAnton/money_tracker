# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        LAYOUT_INPUT_PARSER = {
          AddExpenseLayout.name => AddExpenseInputParser
        }.freeze

        def self.input_parsers(layout)
          LAYOUT_INPUT_PARSER[layout.name] || default_input_parser
        end

        def self.default_input_parser
          InputParserBase
        end
      end
    end
  end
end
