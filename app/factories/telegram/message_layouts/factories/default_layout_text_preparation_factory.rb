# frozen_string_literal: true

module Telegram
  module MessageLayouts
        module Factories
          class DefaultLayoutTextPreparationFactory < BaseFactory
            define(:action_number) do
              Support::ActionNumberTextPreparationService
            end

            define(:value_input, clean_white_space: true) do
              Support::TextPreparationService
            end
          end
        end
  end
end
