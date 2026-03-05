# frozen_string_literal: true

module Telegram
  module MessageLayouts
        module Factories
          class NewLayoutInputParserFactory < BaseFactory
            multi_define(
              :list_all_actions,
              :back_to_index
            ) do
              Telegram::ActionInputParser
            end

            define(:enter_spreadsheets_params) do
              Telegram::NewSpreadsheetInputParser
            end
          end
        end
  end
end
