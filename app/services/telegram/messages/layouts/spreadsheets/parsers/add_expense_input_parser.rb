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
              layout_params_factory(action_name, parsed_input)
                .build
                .layout_params
            end

            def parsed_input
              parse(
                input_parser_factory(action_name),
                text_preparation_factory(action_name).prepared_text
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

            def input_parser_factory(factory_name)
              InputParserFactory.run!(factory_name: factory_name, style: :initializer)
            end

            def text_preparation_factory(factory_name)
              Support::TextPreparationFactory.run!(factory_name: factory_name, style: :initializer).tap do |tp|
                tp.text = text
              end
            end

            def layout_params_factory(factory_name, parsed_input)
              Builders::LayoutParamsFactory.run!(factory_name: factory_name, style: :initializer).tap do |lp|
                lp.params = parsed_input
              end
            end
          end
        end
      end
    end
  end
end
