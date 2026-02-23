# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Parsers
          class AddExpenseInputParser < InputParserBase
            string :text
            string :layout_klass, default: 'Telegram::Messages::Layouts::Spreadsheets::Layouts::AddExpenseLayout'

            DEFAULT_ABSTRACT_FACTORY = Factories::DefaultLayoutFactory
            ABSTRACT_FACTORY_BY_LAYOUT = {
              'Telegram::Messages::Layouts::Spreadsheets::Layouts::AddExpenseLayout' =>
                Factories::AddExpenseLayoutFactory
            }.freeze

            def execute
              action_name
              layout_params
            end

            private

            def action_name
              @action_name ||= layout.action_name_for(action_number)
            end

            def action_number
              text.split(')').first.to_i
            end

            def layout
              @layout ||= layout_klass.constantize
            end

            def layout_params
              layout_params_builder(builder_name: action_name, layout_params: parsed_input)
                .build
                .layout_params
            end

            def parsed_input
              parse(
                input_parser(parser_name: action_name),
                text_preparation(preparation_name: action_name).prepared_text
              ) || {}
            end

            def parse(parser, txt)
              parser.parse(txt).transform_values(&:to_s)
            rescue Parslet::ParseFailed
              nil
            end

            def layout_params_builder(builder_name:, layout_params:)
              factory.layout_params_factory(builder_name, layout_params)
            end

            def input_parser(parser_name:)
              factory.input_parser_factory(parser_name)
            end

            def text_preparation(preparation_name:)
              factory.text_preparation_factory(preparation_name, text)
            end

            def factory
              @factory ||= abstract_factory_for_layout.run
            end

            def abstract_factory_for_layout
              ABSTRACT_FACTORY_BY_LAYOUT.fetch(layout.name, DEFAULT_ABSTRACT_FACTORY)
            end
          end
        end
      end
    end
  end
end
