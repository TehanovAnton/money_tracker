# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Factories
          class NewLayoutTextPreparationFactory < BaseFactory
            define(:list_all_actions) do
              Telegram::Messages::Layouts::Spreadsheets::Support::ActionNumberTextPreparation
            end

            define(:back_to_index) do
              Telegram::Messages::Layouts::Spreadsheets::Support::ActionNumberTextPreparation
            end

            define(:enter_spreadsheets_params, clean_white_space: true) do
              Telegram::Messages::Layouts::Spreadsheets::Support::TextPreparation
            end
          end
        end
      end
    end
  end
end
