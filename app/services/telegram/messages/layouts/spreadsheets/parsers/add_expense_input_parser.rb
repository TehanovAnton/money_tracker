# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Parsers
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
              Layouts::AddExpenseLayout.action_name_for(action_number)
            end

            def layout_params
              factory.layout_params_factory(action_name, parsed_input)
                     .build
                     .layout_params
            end

            def parsed_input
              parse(
                factory.input_parser_factory(action_name),
                factory.text_preparation_factory(action_name, text).prepared_text
              ) || {}
            end

            def input_parser(value_alias, **options)
              Telegram::AddExpenseInputParser.new(value_alias, **options)
            end

            def parse(parser, txt)
              parser.parse(txt).transform_values(&:to_s)
            rescue Parslet::ParseFailed
              nil
            end

            def factory
              @factory ||= Factories::ConcreteFactory.run
            end
          end
        end
      end
    end
  end
end
