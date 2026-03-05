# frozen_string_literal: true

module Telegram
  module MessageLayouts
        class ListTablesInputParser < BaseParser
          string :layout_klass, default: 'Telegram::MessageLayouts::ListTables'

          private

          def action_name
            @action_name ||= layout.action_name_for(action_number)
          end

          def parsed_input
            parsed = parse(
              input_parser(parser_name: parser_factory_name),
              text_preparation(preparation_name: text_preparation_factory_name).prepared_text
            ) || {}
            return parsed unless action_name == :delete_table

            parsed.merge(action_number: parsed[:action_number] || action_number.to_s)
          end

          def layout_params_builder_name
            layout_params_factory_name
          end

          def input_parser(parser_name:)
            factory.input_parser_factory(parser_name)
          end

          def parser_factory_name
            action_name || :list_all_actions
          end

          def text_preparation_factory_name
            action_name || :list_all_actions
          end

          def layout_params_factory_name
            action_name || :list_all_actions
          end
        end
  end
end
