# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Factories
          class NewLayoutParamsFactory < BaseFactory
            multi_define(
              :list_all_actions,
              :back_to_index
            ) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::DefaultLayoutParamsBuilder
            end

            define(:enter_spreadsheets_params,
                   [{ name: :action_number }, { name: :document_id }, { name: :expense_range }]) do
              Telegram::Messages::Layouts::Spreadsheets::Builders::LayoutParamsBuilder
            end
          end
        end
      end
    end
  end
end
