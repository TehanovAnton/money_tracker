# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class InputParserBase < ActiveInteraction::Base
          string :text

          def execute
            layout_params
          end

          private

          def layout_params
            raise StandardError, 'Not implemented'
          end

          def input_parser(kind = :value_input)
            return LayoutInputParser.new(:spreadsheet_id) if kind == :value_input

            ActionInputParser.new
          end

          def parsed_input
            @parsed_input ||= parse(input_parser, prepared_text) ||
                              parse(input_parser(:action_input), prepared_text) ||
                              {}
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
