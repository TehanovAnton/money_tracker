# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class IndexInputParser < ActiveInteraction::Base
          class InvalidInputError < StandardError; end

          string :text

          def execute
            layout_params
          end

          def layout_params
            {
              action_number: parsed_input.fetch(:action_number, '0')
            }.compact
          end

          def input_parser
            ActionInputParser.new
          end

          def parsed_input
            @parsed_input ||= parse(input_parser, prepared_text) || {}
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
