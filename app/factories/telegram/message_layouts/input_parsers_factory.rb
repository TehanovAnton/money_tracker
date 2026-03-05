# frozen_string_literal: true

module Telegram
  module MessageLayouts
        class InputParsersFactory < BaseFactory
          define(:base) do
            DefaultInputParser
          end

          define(:new) do
            NewInputParser
          end

          define(:list_tables) do
            ListTablesInputParser
          end

          define(:add_expense) do
            AddExpenseInputParser
          end
        end
  end
end
