# frozen_string_literal: true

module Telegram
  module MessageLayouts
        module Factories
          class DefaultLayoutInputParserFactory < BaseFactory
            define(:action_number) do
              Telegram::ActionInputParser
            end

            define(:value_input, :document_id) do
              Telegram::LayoutInputParser
            end
          end
        end
  end
end
