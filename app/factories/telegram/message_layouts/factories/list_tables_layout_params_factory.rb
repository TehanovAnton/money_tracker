# frozen_string_literal: true

module Telegram
  module MessageLayouts
        module Factories
          class ListTablesLayoutParamsFactory < BaseFactory
            multi_define(
              :list_all_actions,
              :list_tables,
              :edit_table,
              :back_to_index,
              list_all_actions: { inline_options: [[{ name: :action_number }]] },
              list_tables: { inline_options: [[{ name: :action_number }]] },
              edit_table: { inline_options: [[{ name: :action_number }]] },
              back_to_index: { inline_options: [[{ name: :action_number }]] }
            ) do
              Telegram::MessageLayouts::Builders::LayoutParamsBuilder
            end

            multi_define(
              :data_actions,
              :delete_table,
              data_actions: { inline_options: [[{ name: :action_number }, { name: :document_id }]] },
              delete_table: { inline_options: [[{ name: :action_number }, { name: :document_id }]] }
            ) do
              Telegram::MessageLayouts::Builders::LayoutParamsBuilder
            end
          end
        end
  end
end
