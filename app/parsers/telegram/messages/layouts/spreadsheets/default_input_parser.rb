# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class DefaultInputParser < BaseParser
          private

          def action_name
            @action_name ||= layout&.action_name_for(action_number)
          end

          def input_parser(parser_name: :value_input)
            factory.input_parser_factory(parser_name)
          end

          def parsed_input
            @parsed_input ||= parse(input_parser(parser_name: default_factory_name), prepared_text) || {}
          end

          def prepared_text
            text_preparation(preparation_name: default_factory_name).prepared_text
          end

          def layout_params_builder_name
            default_factory_name
          end

          def default_factory_name
            return :value_input if value_input?

            :action_number
          end

          def value_input?
            text.split(')').size > 1
          end
        end
      end
    end
  end
end
