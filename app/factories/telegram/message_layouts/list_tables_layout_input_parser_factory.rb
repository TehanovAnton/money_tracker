# frozen_string_literal: true

module Telegram
  module MessageLayouts
    class ListTablesLayoutInputParserFactory < BaseFactory
      multi_define(
        :list_all_actions,
        :list_tables,
        :edit_table,
        :back_to_index
      ) do
        Telegram::ActionInputParser
      end

      define(:data_actions, :document_id) do
        Telegram::LayoutInputParser
      end

      define(:delete_table) do
        Telegram::DeleteSpreadsheetInputParser
      end
    end
  end
end
