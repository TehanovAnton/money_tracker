# frozen_string_literal: true

module Telegram
  module MessageLayouts
        module Factories
          class NewLayoutTextPreparationFactory < BaseFactory
            multi_define(
              :list_all_actions,
              :back_to_index
            ) do
              Support::ActionNumberTextPreparationService
            end

            define(:enter_spreadsheets_params, clean_white_space: true) do
              Support::TextPreparationService
            end
          end
        end
  end
end
