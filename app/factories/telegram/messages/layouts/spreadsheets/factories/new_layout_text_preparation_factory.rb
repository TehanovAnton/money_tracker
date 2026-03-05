# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Factories
          class NewLayoutTextPreparationFactory < BaseFactory
            multi_define(
              :list_all_actions,
              :back_to_index
            ) do
              Support::ActionNumberTextPreparation
            end

            define(:enter_spreadsheets_params, clean_white_space: true) do
              Support::TextPreparation
            end
          end
        end
      end
    end
  end
end
