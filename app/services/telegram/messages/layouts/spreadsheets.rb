# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        def self.input_parsers(layout)
          layout_input_parser[layout.name] || default_input_parser
        end

        def self.default_input_parser
          Parsers::InputParserBase
        end

        def self.layout_input_parser
          @layout_input_parser ||= {
            Layouts::AddExpenseLayout.name => Parsers::AddExpenseInputParser
          }.freeze
        end
      end
    end
  end
end
