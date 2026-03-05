# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        module Factories
          class DefaultLayoutTextPreparationFactory < BaseFactory
            define(:action_number) do
              Support::ActionNumberTextPreparation
            end

            define(:value_input, clean_white_space: true) do
              Support::TextPreparation
            end
          end
        end
      end
    end
  end
end
