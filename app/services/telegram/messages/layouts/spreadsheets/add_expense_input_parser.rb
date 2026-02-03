# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class AddExpenseInputParser < InputParserBase
          string :text

          def execute
            action_name
            layout_params
          end

          private

          def action_name
            @action_name ||= action_name_for
          end

          def action_name_for
            action_number = text.split(')').first.to_i
            AddExpenseLayout.action_name_for(action_number)
          end

          def layout_params
            {
              action_number: parsed_input.fetch(:action_number, nil),
              date: parsed_input.fetch(:date, nil),
              money: parsed_input.fetch(:money, nil)&.to_f,
              category: parsed_input.fetch(:category, nil),
              comment: parsed_input.fetch(:comment, nil)
            }.compact
          end

          def parsed_input
            options = parser_options[action_name]
            @parsed_input ||= parse(
              input_parser(options[:value_alias], kind: options[:kind]),
              prepared_text(clean_white_space: options[:clean_white_space])
            ) || {}
          end

          # refactor by using factory
          def parser_options
            {
              enter_date: { value_alias: :date, kind: :date_input, clean_white_space: true },
              enter_money: { value_alias: :money, kind: :money_input, clean_white_space: true },
              enter_category: { value_alias: :category, kind: :category_input, clean_white_space: false },
              enter_comment: { value_alias: :comment, kind: :comment_input, clean_white_space: false }
            }
          end

          def input_parser(value_alias, **options)
            Telegram::AddExpenseInputParser.new(value_alias, **options)
          end

          def parse(parser, txt)
            parser.parse(txt).transform_values(&:to_s)
          rescue Parslet::ParseFailed
            nil
          end

          def prepared_text(clean_white_space: true)
            return text unless clean_white_space

            text.gsub(/\s/, '')
          end
        end
      end
    end
  end
end
