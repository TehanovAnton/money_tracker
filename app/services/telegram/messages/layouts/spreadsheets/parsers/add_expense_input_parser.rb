# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Parsers
          class AddExpenseInputParser < ParserBase
            string :text
            string :layout_klass, default: 'Telegram::Messages::Layouts::Spreadsheets::Layouts::AddExpenseLayout'

            private

            def action_name
              @action_name ||= layout.action_name_for(action_number)
            end

            def parsed_input
              parse(
                input_parser(parser_name: action_name),
                text_preparation(preparation_name: action_name).prepared_text
              ) || {}
            end

            def layout_params_builder_name
              action_name
            end

            def input_parser(parser_name:)
              factory.input_parser_factory(parser_name)
            end
          end
        end
      end
    end
  end
end
