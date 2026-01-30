# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class AddExpenseInputParser < InputParserBase
          string :text

          def execute
            layout_params
          end

          private

          def layout_params
            {
              action_number: parsed_input.fetch(:action_number, nil),
              date: parsed_input.fetch(:date, nil),
              money: parsed_input.fetch(:money, nil)&.to_f
            }.compact
          end

          def parsed_input
            @parsed_input ||= parse(input_parser(:date, kind: :date_input), prepared_text) ||
                              parse(input_parser(:money, kind: :money_input), prepared_text) ||
                              {}
          end

          def input_parser(value_alias, **options)
            Telegram::AddExpenseInputParser.new(value_alias, **options)
          end

          def parse(parser, txt)
            parser.parse(txt).transform_values(&:to_s)
          rescue Parslet::ParseFailed
            nil
          end

          def prepared_text
            text.gsub(/\s/, '')
          end
        end
      end
    end
  end
end
