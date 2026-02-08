# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class InputParsersFactory < BaseFactory
          define(:base) do
            Parsers::InputParserBase
          end

          define(:add_expense) do
            Parsers::AddExpenseInputParser
          end
        end
      end
    end
  end
end
