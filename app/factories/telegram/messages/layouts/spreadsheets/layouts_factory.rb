# frozen_string_literal: true

module Telegram
  module Messages
    module Layouts
      module Spreadsheets
        class LayoutsFactory < BaseFactory
          define(:index) do
            Index
          end

          define(:new) do
            New
          end

          define(:delete) do
            Delete
          end

          define(:list_tables) do
            ListTables
          end

          define(:data_actions) do
            DataActionsLayout
          end

          define(:add_expense) do
            AddExpenseLayout
          end
        end
      end
    end
  end
end
