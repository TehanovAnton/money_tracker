# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class InputParsersFactory < BaseFactory
          define(:base) do
            InputParserBase
          end
        end
      end
    end
  end
end
