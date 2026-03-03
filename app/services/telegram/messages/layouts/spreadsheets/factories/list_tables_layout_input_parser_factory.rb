# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Factories
          class ListTablesLayoutInputParserFactory < BaseFactory
            define(:list_all_actions) do
              Telegram::ActionInputParser
            end

            define(:list_tables) do
              Telegram::ActionInputParser
            end

            define(:edit_table) do
              Telegram::ActionInputParser
            end

            define(:data_actions, :document_id) do
              Telegram::LayoutInputParser
            end

            define(:delete_table) do
              Telegram::DeleteSpreadsheetInputParser
            end

            define(:back_to_index) do
              Telegram::ActionInputParser
            end
          end
        end
      end
    end
  end
end
