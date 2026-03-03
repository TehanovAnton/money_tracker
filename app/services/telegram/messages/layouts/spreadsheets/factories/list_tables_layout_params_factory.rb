# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Factories
          class ListTablesLayoutParamsFactory < BaseFactory
            define(:list_all_actions, [{ name: :action_number }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:list_tables, [{ name: :action_number }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:edit_table, [{ name: :action_number }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:data_actions, [{ name: :action_number }, { name: :document_id }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:delete_table, [{ name: :action_number }, { name: :document_id }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end

            define(:back_to_index, [{ name: :action_number }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end
          end
        end
      end
    end
  end
end
