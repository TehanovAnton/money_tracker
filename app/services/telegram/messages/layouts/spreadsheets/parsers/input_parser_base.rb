# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Parsers
          class InputParserBase < ActiveInteraction::Base
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
              return :value_input if text.include?(')')

              :action_input
            end

            def layout_params
              layout_params_builder(builder_name: action_name, layout_params: parsed_input)
                .build
                .layout_params
            end

            def layout_params_builder(builder_name:, layout_params:)
              factory.layout_params_factory(builder_name, layout_params)
            end

            def input_parser(parser_name: :value_input)
              return LayoutInputParser.new(:document_id) if parser_name == :value_input

              ActionInputParser.new
            end

            def parsed_input
              @parsed_input ||= parse(input_parser(parser_name: action_name), prepared_text) || {}
            end

            def parse(parser, txt)
              parser.parse(txt).transform_values(&:to_s)
            rescue Parslet::ParseFailed
              nil
            end

            def prepared_text
              text_preparation(preparation_name: action_name).prepared_text
            end

            def text_preparation(preparation_name:)
              factory.text_preparation_factory(preparation_name, text)
            end

            def factory
              @factory ||= Factories::AddExpenseLayoutFactory.run
            end
          end
        end
      end
    end
  end
end
