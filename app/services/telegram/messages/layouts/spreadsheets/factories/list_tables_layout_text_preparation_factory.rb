# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Factories
          class ListTablesLayoutTextPreparationFactory < BaseFactory
            define(:list_all_actions) do
              Telegram::Messages::Layouts::Spreadsheets::Support::ActionNumberTextPreparation
            end

            define(:list_tables) do
              Telegram::Messages::Layouts::Spreadsheets::Support::ActionNumberTextPreparation
            end

            define(:edit_table) do
              Telegram::Messages::Layouts::Spreadsheets::Support::ActionNumberTextPreparation
            end

            define(:data_actions, clean_white_space: true) do
              Telegram::Messages::Layouts::Spreadsheets::Support::TextPreparation
            end

            define(:delete_table, clean_white_space: true) do
              Telegram::Messages::Layouts::Spreadsheets::Support::TextPreparation
            end

            define(:back_to_index) do
              Telegram::Messages::Layouts::Spreadsheets::Support::ActionNumberTextPreparation
            end
          end
        end
      end
    end
  end
end
